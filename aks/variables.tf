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


variable "location" {
  default     = "East US"
  type        = string
  description = "The Azure location"
}

variable "k8s_version" {
  default     = "1.19.9"
  type        = string
  description = "The version of Kubernetes"
}

variable "ssh_key" {
  type        = string
  description = "The SSH public key"
}
