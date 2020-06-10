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

// Panorama
variable "panorama_ip" {
  description = "The Panorama IP address"
  type        = string
}

variable "panorama_auth_key" {
  description = "The Panorama auth key for VM-series registration"
  type        = string
}

variable "helm_depends_on" {
  default     = ""
  description = "Module dependency list"
}

variable "panorama_device_group" {
  description = "The Panorama device group"
  type        = string
}

variable "panorama_template_stack" {
  description = "The Panorama template stack"
  type        = string
}

variable "panorama_collector_group" {
  description = "The Panorama log collector group"
  type        = string
}

// CNI container
variable "k8s_cni_image" {
  description = "The CNI container image"
  default     = "gcr.io/paloaltonetworksgcp-public/pan-cni"
  type        = string
}

variable "k8s_cni_version" {
  description = "The CNI container image version tag"
  default     = "1.0.0-b5"
  type        = string
}

variable "k8s_cni_bin_dir" {
  description = "The CNI container binaries directory (Use /host/opt/cni/bin for EKS and AKS.  Use /opt/cni/bin for minikube)"
  default     = "/home/kubernetes/bin"
  type        = string
}

variable "k8s_cni_conf_name" {
  description = "The CNI container configuration file (Use 10-aws.conflist for AWS.  Use 10-azure.conflist for AKS.  Use k8s.conflist for minikube.)"
  default     = "10-calico.conflist"
  type        = string
}

// MP container
variable "k8s_mp_init_image" {
  description = "The MP init container image"
  default     = "gcr.io/paloaltonetworksgcp-public/pan-mgmt-init"
  type        = string
}

variable "k8s_mp_init_version" {
  description = "The MP init container image version tag"
  default     = "1.0.0-b5"
  type        = string
}

variable "k8s_mp_image" {
  description = "The MP container image"
  default     = "gcr.io/paloaltonetworksgcp-public/paloaltonetworks/panos_cn_mgmt"
  type        = string
}

variable "k8s_mp_image_version" {
  description = "The MP container image version tag"
  default     = "9.2.0-b46"
  type        = string
}

variable "k8s_mp_cpu" {
  description = "The MP container CPU request"
  default     = "4"
  type        = string
}

variable "k8s_mp_mem" {
  description = "The MP container memory request"
  default     = "4.0Gi"
  type        = string
}

// DP container
variable "k8s_dp_image" {
  description = "The DP container image"
  default     = "gcr.io/paloaltonetworksgcp-public/paloaltonetworks/panos_cn_ngfw"
  type        = string
}

variable "k8s_dp_image_version" {
  description = "The DP container image version tag"
  default     = "9.2.0-b46"
  type        = string
}

variable "k8s_dp_cpu" {
  description = "The DP container CPU request"
  default     = "1"
  type        = string
}

variable "k8s_dp_mem" {
  description = "The DP container memory request"
  default     = "2.25Gi"
  type        = string
}
