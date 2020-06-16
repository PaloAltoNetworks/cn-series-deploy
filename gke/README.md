Google Kubernetes Engine
===

Overview
---
This Terraform plan deploys a Kubernetes cluster in Google Kubernetes Engine (GKE).

Steps
---

1. Log into Google Cloud Platform using its CLI interface.
```bash
$ gcloud login
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
$ gcloud container clusters get-credentials $(terraform output cluster_name) --region $(terraform output cluster_location) --project $(terraform output cluster_project)
```

7. Verify the cluster nodes have been built and are in a **Ready** status.
```bash
$ kubectl get nodes
NAME                                                  STATUS   ROLES    AGE     VERSION
gke-cnseries-testing-cnseries-testing-1e1ebbe6-6d3s   Ready    <none>   7m21s   v1.14.10-gke.36
gke-cnseries-testing-cnseries-testing-c89de143-0710   Ready    <none>   7m53s   v1.14.10-gke.36
gke-cnseries-testing-cnseries-testing-d320cbc7-rtm2   Ready    <none>   7m51s   v1.14.10-gke.36
```

8. You may now proceed to deploy the CN-Series firewall.
