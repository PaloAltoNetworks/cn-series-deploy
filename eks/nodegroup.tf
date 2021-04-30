############################################################################################
# Copyright 2020 Palo Alto Networks.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
############################################################################################


// Nodegroup IAM roles and policies
resource "aws_iam_role" "NodeInstanceRole" {
  name = "${random_pet.prefix.id}-NodeInstanceRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeInstanceRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeInstanceRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeInstanceRole.name
}


// Instance profile
resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "${random_pet.prefix.id}-eks-instance-profile"
  role = aws_iam_role.NodeInstanceRole.name
}


// Security groups and rules
resource "aws_security_group" "NodeGroupSecurityGroup" {
  name        = "${random_pet.prefix.id}-nodegroup-NodeGroupSecurityGroup"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.cluster_vpc.id
  tags = {
    Name                                                         = "${random_pet.prefix.id}-NodeGroupSecurityGroup"
    "kubernetes.io/cluster/${aws_eks_cluster.ControlPlane.name}" = "owned"
  }
}

resource "aws_security_group_rule" "EgressInterCluster" {
  type                     = "egress"
  description              = "Allow control plane to communicate with worker nodes in group (kubelet and workload TCP ports)"
  security_group_id        = aws_security_group.ControlPlaneSecurityGroup.id
  source_security_group_id = aws_security_group.NodeGroupSecurityGroup.id
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "EgressNodeGroupAllowAll" {
  type              = "egress"
  security_group_id = aws_security_group.NodeGroupSecurityGroup.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "EgressInterClusterAPI" {
  type                     = "egress"
  description              = "Allow control plane to communicate with worker nodegroup (workloads using HTTPS port, commonly used with extension API servers)"
  security_group_id        = aws_security_group.ControlPlaneSecurityGroup.id
  source_security_group_id = aws_security_group.NodeGroupSecurityGroup.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "IngressInterCluster" {
  type                     = "ingress"
  description              = "Allow worker nodegroup to communicate with control plane (kubelet and workload TCP ports)"
  security_group_id        = aws_security_group.NodeGroupSecurityGroup.id
  source_security_group_id = aws_security_group.ControlPlaneSecurityGroup.id
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "IngressInterClusterAPI" {
  type                     = "ingress"
  description              = "Allow worker nodegroup to communicate with control plane (workloads using HTTPS port, commonly used with extension API servers)"
  security_group_id        = aws_security_group.NodeGroupSecurityGroup.id
  source_security_group_id = aws_security_group.ControlPlaneSecurityGroup.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "IngressInterClusterCP" {
  type                     = "ingress"
  description              = "Allow control plane to receive API requests from worker nodegroup"
  security_group_id        = aws_security_group.ControlPlaneSecurityGroup.id
  source_security_group_id = aws_security_group.NodeGroupSecurityGroup.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "SSHIPv4" {
  type              = "ingress"
  description       = "Allow SSH access to worker nodegroup"
  security_group_id = aws_security_group.NodeGroupSecurityGroup.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "SSHIPv6" {
  type              = "ingress"
  description       = "Allow SSH access to worker nodegroup"
  security_group_id = aws_security_group.NodeGroupSecurityGroup.id
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}


// Grab the latest AMI
data "aws_ssm_parameter" "latest_ubuntu" {
    name = "/aws/service/canonical/ubuntu/server/bionic/stable/current/amd64/hvm/ebs-gp2/ami-id"
}
# data "aws_ami" "latest_ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"] # Canonical

#   filter {
#     name   = "name"
#     values = ["ubuntu-eks/k8s_${var.k8s_version}/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

// Create the user-data field
locals {
  node_group_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.ControlPlane.endpoint}' --b64-cluster-ca '${aws_eks_cluster.ControlPlane.certificate_authority.0.data}' '${aws_eks_cluster.ControlPlane.name}'
USERDATA
}

// Launch template

resource "aws_launch_template" "NodeGroupLaunchTemplate" {
  name = "${random_pet.prefix.id}-NodeGroupLaunchTemplate"
  iam_instance_profile {
    name = aws_iam_instance_profile.node_instance_profile.name
  }
  key_name      = var.ssh_key_name
  instance_type = var.instance_type
  image_id      = data.aws_ssm_parameter.latest_ubuntu.value
  #image_id      = data.aws_ami.latest_ubuntu.image_id
  user_data     = base64encode(local.node_group_userdata)
  network_interfaces {
    device_index = 0
    security_groups = [
      aws_security_group.ClusterSharedNodeSecurityGroup.id,
      aws_security_group.NodeGroupSecurityGroup.id
    ]
    associate_public_ip_address = true
  }
}

// Autoscaling Group
resource "aws_autoscaling_group" "NodeGroup" {
  name = "${random_pet.prefix.id}-NodeGroup"
  # aws_launch_template = aws_launch_template.NodeGroupLaunchTemplate.id
  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  vpc_zone_identifier = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id,
    aws_subnet.public_subnet_c.id
  ]

  launch_template {
    id      = aws_launch_template.NodeGroupLaunchTemplate.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${random_pet.prefix.id}-Node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.ControlPlane.name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
