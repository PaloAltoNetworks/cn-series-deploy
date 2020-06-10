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

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "cluster_location" {
  description = "The GKE cluster zone"
  type        = string
}

variable "cluster_project" {
  description = "The GKE cluster project"
  type        = string
}

variable "cluster_network_name" {
  type        = string
  description = "The VPC network name"
}

variable "cluster_subnetwork_name" {
  type        = string
  description = "The VPC subnet name"
}

variable "cluster_secondary_range_name" {
  type        = string
  description = "Pod subnet name"
}

variable "services_secondary_range_name" {
  type        = string
  description = "Service subnet name"
}

variable "cluster_num_nodes" {
  description = "Number of GKE nodes"
  type        = number
}


variable "kubeconfig" {
  default = ""
}

variable "refresh" {
  default = ""
}
