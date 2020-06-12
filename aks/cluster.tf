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


resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-k8s"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = "1.14.8"
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name               = "default"
    node_count         = 2
    vm_size            = "Standard_D8s_v3"
    vnet_subnet_id     = azurerm_subnet.aks_subnet.id
    availability_zones = ["1", "2"]
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = var.ssh_key
    }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  addon_profile {
    kube_dashboard {
      enabled = var.kube_dashboard_enabled
    }
  }

}
