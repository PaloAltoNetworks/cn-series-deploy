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


// Random ID
resource "random_pet" "prefix" {}

// Get the availability zones
data "aws_availability_zones" "available" {}


// Cluster IAM roles and policies
resource "aws_iam_role" "ServiceRole" {
  name = "${random_pet.prefix.id}-ServiceRole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ServiceRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.ServiceRole.name
}

resource "aws_iam_role_policy" "PolicyNLB" {
  name   = "${random_pet.prefix.id}-PolicyNLB"
  role   = aws_iam_role.ServiceRole.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "elasticloadbalancing:*",
                "ec2:CreateSecurityGroup",
                "ec2:Describe*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "PolicyCloudWatchMetrics" {
  name   = "${random_pet.prefix.id}-PolicyCloudWatchMetrics"
  role   = aws_iam_role.ServiceRole.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}


// VPC build
resource "aws_vpc" "cluster_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "${random_pet.prefix.id}-VPC"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

// Public and private subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "192.168.0.0/19"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${random_pet.prefix.id}-PublicSubnetA",
    "kubernetes.io/role/elb" = "1"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "192.168.32.0/19"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${random_pet.prefix.id}-PublicSubnetB",
    "kubernetes.io/role/elb" = "1"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${random_pet.prefix.id}-PublicSubnetC",
    "kubernetes.io/role/elb" = "1"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name                              = "${random_pet.prefix.id}-PrivateSubnetA",
    "kubernetes.io/role/internal-elb" = "1"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "192.168.128.0/19"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name                              = "${random_pet.prefix.id}-PrivateSubnetB",
    "kubernetes.io/role/internal-elb" = "1"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id                  = aws_vpc.cluster_vpc.id
  cidr_block              = "192.168.160.0/19"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false
  tags = {
    Name                              = "${random_pet.prefix.id}-PrivateSubnetC",
    "kubernetes.io/role/internal-elb" = "1"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

// Route tables and subnet associations
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${random_pet.prefix.id}-PrivateRouteTableA"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${random_pet.prefix.id}-PrivateRouteTableB"
  }
}

resource "aws_route_table" "private_route_table_c" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${random_pet.prefix.id}-PrivateRouteTableC"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${random_pet.prefix.id}-PublicRouteTable"
  }
}

resource "aws_route_table_association" "private_table_assoc_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route_table_association" "private_table_assoc_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}

resource "aws_route_table_association" "private_table_assoc_c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_route_table_c.id
}

resource "aws_route_table_association" "public_table_assoc_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_table_assoc_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_table_assoc_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_route_table.id
}

// Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = {
    Name = "${random_pet.prefix.id}-IGW"
  }
}

// Elastic IP for the NAT gateway
resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "${random_pet.prefix.id}-EIP"
  }
}

// NAT gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "${random_pet.prefix.id}-NGW"
  }
}

// Security groups and rules
resource "aws_security_group" "ControlPlaneSecurityGroup" {
  name        = "${random_pet.prefix.id}-cluster-ControlPlaneSecurityGroup"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = aws_vpc.cluster_vpc.id
  tags = {
    Name = "${random_pet.prefix.id}-ControlPlaneSecurityGroup"
  }
}

resource "aws_security_group" "ClusterSharedNodeSecurityGroup" {
  name        = "${random_pet.prefix.id}-cluster-ClusterSharedNodeSecurityGroup"
  description = "Communication between all nodes in the cluster"
  vpc_id      = aws_vpc.cluster_vpc.id
  tags = {
    Name = "${random_pet.prefix.id}-ClusterSharedNodeSecurityGroup"
  }
}

resource "aws_security_group_rule" "IngressDefaultClusterToNodeSG" {
  type                     = "ingress"
  description              = "Allow managed and unmanaged nodes to communicate with each other (all ports)"
  security_group_id        = aws_security_group.ClusterSharedNodeSecurityGroup.id
  source_security_group_id = aws_eks_cluster.ControlPlane.vpc_config[0].cluster_security_group_id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
}

resource "aws_security_group_rule" "IngressInterNodeGroupSG" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with each other (all ports)"
  security_group_id        = aws_security_group.ClusterSharedNodeSecurityGroup.id
  source_security_group_id = aws_security_group.ClusterSharedNodeSecurityGroup.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
}

resource "aws_security_group_rule" "IngressNodeToDefaultClusterSG" {
  type                     = "ingress"
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  security_group_id        = aws_eks_cluster.ControlPlane.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.ClusterSharedNodeSecurityGroup.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
}

resource "aws_security_group_rule" "EgressClusterSharedNodeAllowAll" {
  type              = "egress"
  security_group_id = aws_security_group.ClusterSharedNodeSecurityGroup.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

// Cluster
resource "aws_eks_cluster" "ControlPlane" {
  name     = "${random_pet.prefix.id}-K8s"
  role_arn = aws_iam_role.ServiceRole.arn
  version  = var.k8s_version

  vpc_config {
    security_group_ids = [aws_security_group.ControlPlaneSecurityGroup.id]
    subnet_ids = [
      aws_subnet.private_subnet_a.id,
      aws_subnet.private_subnet_b.id,
      aws_subnet.private_subnet_c.id,
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id,
      aws_subnet.public_subnet_c.id
    ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}

