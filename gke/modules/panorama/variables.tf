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

variable "panorama_name" {
  description = "The name of the Panorama instance"
  type        = string
}

variable "panorama_zone" {
  description = "The GCP zone in which the Panorama instance will be deployed"
  type        = string
}

variable "panorama_image" {
  description = "The GCE image for the Panorama instance"
  type        = string
}

variable "panorama_machine_type" {
  default     = "n1-standard-8"
  description = "The GCE machine type for the Panorama instance"
  type        = string
}

variable "panorama_machine_cpu" {
  description = "The GCE machine minumum CPU type for the Panorama instance"
  default     = "Intel Haswell"
  type        = string
}

variable "panorama_subnet" {
  description = "The management subnet of the firewall instance"
  type        = string
}

variable "panorama_firewall" {
  description = "The GCP firewall rule for the firewall intance management interface"
  type        = string
}
