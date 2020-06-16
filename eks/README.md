Elastic Kubernetes Service
===

Overview
---
This Terraform plan deploys a Kubernetes cluster in Amazon's Elastic Kubernetes Service (EKS).

Steps
---

1. Configure the AWS CLI with your credentials.
```bash
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: ENTER
```

2. Create a `terraform.tfvars` file and add the following variables and their associated values.
```bash
location = ""                           # The Azure region
ssh_key = ""                            # The contents of your SSH public key
```

3. Initialize the Terraform providers.
```bash
$ terraform init
```

4. Validate the Terraform plan.
```bash
$ terraform plan
```

5. Apply the Terraform plan.
```bash
$ terraform apply
```

6. Update the kubeconfig file with the new cluster's information.
```bash
$ aws eks update-kubeconfig --name $(terraform output eks_cluster_name)
```

7. Verify the cluster nodes have been built and are in a **Ready** status.
```bash
$ kubectl get nodes
NAME                                           STATUS   ROLES    AGE   VERSION
ip-192-168-42-180.us-west-2.compute.internal   Ready    <none>   42m   v1.14.9
ip-192-168-67-38.us-west-2.compute.internal    Ready    <none>   42m   v1.14.9
```

8. You may now proceed to deploy the CN-Series firewall.
