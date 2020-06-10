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


terraform {
  required_version = ">= 0.12"
}

provider "google" {
  # credentials = file("account.json")
  project = var.project
  region  = var.region
}


module "vpc" {
  source = "./modules/vpc"

  cluster_network_name          = "${var.project}-network"
  cluster_subnetwork_name       = "${var.project}-subnet"
  cluster_subnetwork_cidr_range = "10.0.16.0/20"
  cluster_secondary_range_name  = "pods"
  cluster_secondary_range_cidr  = "10.16.0.0/12"
  services_secondary_range_name = "services"
  services_secondary_range_cidr = "10.1.0.0/20"
  firewall_name                 = "${var.project}-panorama-firewall"
}

module "cluster" {
  source = "./modules/cluster"

  cluster_name                  = "${var.project}-cluster"
  cluster_project               = var.project
  cluster_location              = var.zone
  cluster_network_name          = module.vpc.network_name
  cluster_subnetwork_name       = module.vpc.subnet_name
  cluster_secondary_range_name  = "pods"
  services_secondary_range_name = "services"
  cluster_num_nodes             = 2
}

module "panorama" {
  source = "./modules/panorama"

  panorama_name     = "panorama"
  panorama_zone     = var.zone
  panorama_image    = var.panorama_image
  panorama_subnet   = module.vpc.subnet_id
  panorama_firewall = module.vpc.firewall_id
}

module "helm" {
  source = "./modules/helm"

  panorama_ip       = module.panorama.panorama_ip
  panorama_auth_key = var.panorama_auth_key

  helm_depends_on = [
    module.cluster.cluster_master_ip,
    module.cluster.cluster_name,
    module.cluster.cluster_zone
  ]
}

