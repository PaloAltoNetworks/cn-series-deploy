CN-Series Deployment
===

Overview
---
This Terraform plan leverages the Helm provider to deploy the CN-Series application to a Kubernetes cluster.

Steps
---

1. Create a `terraform.tfvars` file and add the following variables and their associated values.
```bash
k8s_environment = ""                    # The Kubernetes environment (gke|eks|aks|openshift|native)
panorama_ip = ""                        # The Panorama IP address
panorama_auth_key = ""                  # The Panorama auth key for VM-series registration
panorama_device_group = ""              # The Panorama device group
panorama_template_stack = ""            # The Panorama template stack
panorama_collector_group = ""           # The Panorama log collector group
k8s_cni_image = ""                      # The CNI container image
k8s_cni_version = ""                    # The CNI container image version tag
k8s_mp_init_image = ""                  # The MP init container image
k8s_mp_init_version = ""                # The MP init container image version tag
k8s_mp_image = ""                       # The MP container image
k8s_mp_image_version = ""               # The MP container image version tag
k8s_mp_cpu = ""                         # The MP container CPU limit
k8s_dp_image = ""                       # The DP container image
k8s_dp_image_version = ""               # The DP container image version tag
k8s_dp_cpu = ""                         # The DP container CPU limit
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

6. Verify the pods have been deployed and are in a **Running** status.
```bash
$ kubectl get pods -A
NAME                              STATUS   ROLES   AGE   VERSION
aks-default-50806154-vmss000000   Ready    agent   22m   v1.14.8
aks-default-50806154-vmss000001   Ready    agent   22m   v1.14.8
```

8. You may now proceed to configure Panorama and the Kubernetes plugin.
