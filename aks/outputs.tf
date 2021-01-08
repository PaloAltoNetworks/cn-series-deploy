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

output "az_resource_group" {
  value = azurerm_resource_group.rg.name
}

output "az_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}

output "az_cluster_endpoint" {
  value = azurerm_kubernetes_cluster.default.fqdn
}

output "run_this_command_to_configure_kubectl" {
  value = "az aks get-credentials --name ${azurerm_kubernetes_cluster.default.name} --resource-group ${azurerm_resource_group.rg.name}"
}

# output "az_cluster_kubeconfig" {
#   value = azurerm_kubernetes_cluster.default.kube_config_raw
# }
