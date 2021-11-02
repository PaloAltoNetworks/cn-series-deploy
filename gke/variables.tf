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

variable "project" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
}

# Not supported for GKE >= 1.19
# variable "gke_username" {
#   type        = string
#   description = "The cluster master username"
# }

# Not supported for GKE >= 1.19
# variable "gke_password" {
#   type        = string
#   description = "The cluster master password"

#   validation {
#     condition     = length(var.gke_password) >= 16
#     error_message = "The cluster master passsword must be 16 characters or more."
#   }
# }

variable "k8s_version" {
  default     = "1.20" # latest supported version of GKE as of 2021-09-28
  type        = string
  description = "The version of Kubernetes"
}
