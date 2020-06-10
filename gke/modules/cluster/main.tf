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

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.cluster_network_name
  subnetwork = var.cluster_subnetwork_name

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }


}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = "${var.cluster_name}-node-pool"
  location = var.cluster_location
  cluster  = google_container_cluster.primary.name

  node_count = var.cluster_num_nodes

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

// Kubeconfig generation

resource "null_resource" "kubeconfig" {
  triggers = {
    refresh = var.refresh
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kubeconfig
    }
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.cluster_location} --project ${var.cluster_project}"
  }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "rm var.kubeconfig"
  # }

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes
  ]
}

