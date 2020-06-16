Azure Kubernetes Service
===

Overview
---
This Terraform plan deploys a Kubernetes cluster in Microsoft's Azure Kubernetes Service (AKS).

Steps
---

1. Log into Azure using its CLI interface.
```bash
$ az login
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
$ az aks get-credentials --name $(terraform output az_cluster_name) --resource-group $(terraform output az_resource_group)
```

7. Verify the cluster nodes have been built and are in a **Ready** status.
```bash
$ kubectl get nodes
NAME                              STATUS   ROLES   AGE   VERSION
aks-default-50806154-vmss000000   Ready    agent   22m   v1.14.8
aks-default-50806154-vmss000001   Ready    agent   22m   v1.14.8
```

8. You may now proceed to deploy the CN-Series firewall.
