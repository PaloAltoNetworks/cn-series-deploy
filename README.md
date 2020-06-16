# cn-series-deploy
A set of Terraform plans for deploying a Kubernetes cluster protected by a Palo Alto Networks CN-Series Next-Generation Firewall.  Kubernetes environments supported include GKE, EKS, AKS, and OpenShift.

## Requirements

* Panorama
  * [Panorama](https://www.paloaltonetworks.com/network-security/panorama) 10.0.0 or newer
  * Kubernetes plugin for Panorama version 1.0.0 or newer
  * Panorama must be [accessible](https://docs.paloaltonetworks.com/pan-os/9-1/pan-os-admin/firewall-administration/reference-port-number-usage/ports-used-for-panorama.html) from the Kubernetes cluster
* Terraform
  * [Terraform](https://www.terraform.io/downloads.html) 12.0 or newer
* Cloud CLI
  * [Google Cloud SDK](https://cloud.google.com/sdk)
  * [AWS Command Line Interface](https://aws.amazon.com/cli/)
  * [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
  * [OpenShift CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

