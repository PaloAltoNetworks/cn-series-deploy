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

// Project API Services

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"

  # Needs compute.googleapis.com API enabled on Project
  depends_on = [google_project_service.compute]
}

// Cluster definition

data "google_compute_zones" "available" {
  # Needs compute.googleapis.com API enabled on Project
  depends_on = [google_project_service.compute]
}

resource "google_container_cluster" "cluster" {
  name               = "${var.project}-k8s"
  location           = var.region
  min_master_version = var.k8s_version

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  ip_allocation_policy {
    # cluster_secondary_range_name  = var.cluster_secondary_range_name
    # services_secondary_range_name = var.services_secondary_range_name
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  master_auth {
#     Not supported for GKE >= 1.19
#     username = var.gke_username
#     password = var.gke_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  # Needs container.googleapis.com API enabled on Project
  depends_on = [google_project_service.container]
}

// Unmanaged node pool definition
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = "${var.project}-nodepool"
  location = var.region
  cluster  = google_container_cluster.cluster.name

  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-8"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}


