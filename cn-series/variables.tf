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

// Kubernetes
variable "k8s_environment" {
  description = "The Kubernetes environment (gke|eks|aks|openshift|native)"
  type        = string
}

// Panorama
variable "panorama_ip" {
  description = "The Panorama IP address"
  type        = string
}

variable "panorama_auth_key" {
  description = "The Panorama auth key for VM-series registration"
  type        = string
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
  type        = string
}

variable "k8s_cni_version" {
  description = "The CNI container image version tag"
  type        = string
}

// MP container
variable "k8s_mp_init_image" {
  description = "The MP init container image"
  type        = string
}

variable "k8s_mp_init_version" {
  description = "The MP init container image version tag"
  type        = string
}

variable "k8s_mp_image" {
  description = "The MP container image"
  type        = string
}

variable "k8s_mp_image_version" {
  description = "The MP container image version tag"
  type        = string
}

variable "k8s_mp_cpu" {
  description = "The MP container CPU limit"
  type        = string
}

// DP container
variable "k8s_dp_image" {
  description = "The DP container image"
  type        = string
}

variable "k8s_dp_image_version" {
  description = "The DP container image version tag"
  type        = string
}

variable "k8s_dp_cpu" {
  description = "The DP container CPU limit"
  type        = string
}

