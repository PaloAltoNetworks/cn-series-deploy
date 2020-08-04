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

provider "panos" {}

variable "device_groups" {
  default = [
    "aks-dg",
    "eks-dg",
    "gke-dg",
    "k8s-dg",
    "openshift-dg"
  ]
  type = list(string)
}

// Panorama device groups
resource "panos_panorama_device_group" "aks_dg" {
  name        = "aks-dg"
  description = "AKS cluster device group"
}

resource "panos_panorama_device_group" "eks_dg" {
  name        = "eks-dg"
  description = "EKS cluster device group"
}

resource "panos_panorama_device_group" "gke_dg" {
  name        = "gke-dg"
  description = "GKE cluster device group"
}

resource "panos_panorama_device_group" "k8s_dg" {
  name        = "k8s-dg"
  description = "K8s cluster device group"
}

resource "panos_panorama_device_group" "openshift_dg" {
  name        = "openshift-dg"
  description = "OpenShift cluster device group"
}


// Panorama template stacks
resource "panos_panorama_template_stack" "aks_stack" {
  name        = "aks-stack"
  description = "AKS template stack"
  templates   = ["K8S-Network-Setup"]
}

resource "panos_panorama_template_stack" "eks_stack" {
  name        = "eks-stack"
  description = "EKS template stack"
  templates   = ["K8S-Network-Setup"]
}

resource "panos_panorama_template_stack" "gke_stack" {
  name        = "gke-stack"
  description = "GKE template stack"
  templates   = ["K8S-Network-Setup"]
}

resource "panos_panorama_template_stack" "k8s_stack" {
  name        = "k8s-stack"
  description = "K8s template stack"
  templates   = ["K8S-Network-Setup"]
}

resource "panos_panorama_template_stack" "openshift_stack" {
  name        = "openshift-stack"
  description = "OpenShift template stack"
  templates   = ["K8S-Network-Setup"]
}


// Log forwarding profile
resource "panos_panorama_log_forwarding_profile" "cnseries_logs" {
  name             = "cnseries-logging"
  device_group     = "shared"
  description      = "CN-Series log forwarding profile"
  enhanced_logging = true

  match_list {
    name             = "traffic_logs_panorama"
    log_type         = "traffic"
    send_to_panorama = true
  }

  match_list {
    name             = "threat_logs_panorama"
    log_type         = "threat"
    send_to_panorama = true
  }

  match_list {
    name             = "wildfire_logs_panorama"
    log_type         = "wildfire"
    send_to_panorama = true
  }

  match_list {
    name             = "url_logs_panorama"
    log_type         = "url"
    send_to_panorama = true
  }

  match_list {
    name             = "data_logs_panorama"
    log_type         = "data"
    send_to_panorama = true
  }

  match_list {
    name             = "gtp_logs_panorama"
    log_type         = "gtp"
    send_to_panorama = true
  }

  match_list {
    name             = "tunnel_logs_panorama"
    log_type         = "tunnel"
    send_to_panorama = true
  }

  match_list {
    name             = "auth_logs_panorama"
    log_type         = "auth"
    send_to_panorama = true
  }

  match_list {
    name             = "sctp_logs_panorama"
    log_type         = "sctp"
    send_to_panorama = true
  }
}

// Service objects
resource "panos_panorama_service_object" "redis_6379" {
  name             = "redis-6379"
  protocol         = "tcp"
  description      = "Redis on tcp/6379"
  destination_port = "6379"
}

// Dynamic Address Groups

// AKS DAGs
resource "panos_panorama_address_group" "kube_dns_svc" {
  name          = "kube-dns-svc"
  description   = "kube-dns service"
  device_group  = panos_panorama_device_group.aks_dg.name
  dynamic_match = "k8s.cl_aks-cluster.ns_kube-system.svc_kube-dns"
}

resource "panos_panorama_address_group" "redis_backend" {
  name          = "redis-backend"
  description   = "redis backend"
  device_group  = panos_panorama_device_group.aks_dg.name
  dynamic_match = "k8s.cl_aks-cluster.ns_sample-app.tier.backend"
}

resource "panos_panorama_address_group" "redis_master_svc" {
  name          = "redis-master-svc"
  description   = "redis master service"
  device_group  = panos_panorama_device_group.aks_dg.name
  dynamic_match = "k8s.cl_aks-cluster.ns_sample-app.svc_redis-master"
}

resource "panos_panorama_address_group" "redis_slave_svc" {
  name          = "redis-slave-svc"
  description   = "redis slave service"
  device_group  = panos_panorama_device_group.aks_dg.name
  dynamic_match = "k8s.cl_aks-cluster.ns_sample-app.svc_redis-slave"
}

resource "panos_panorama_address_group" "web_frontend" {
  name          = "web-frontend"
  description   = "web frontend"
  device_group  = panos_panorama_device_group.aks_dg.name
  dynamic_match = "k8s.cl_aks-cluster.ns_sample-app.svc_frontend"
}

// EKS DAGs

// GKE DAGs

// K8s DAGs

// OpenShift DAGs


// Security rules
resource "panos_panorama_security_rule_group" "guestbook_rules" {
  # for_each     = toset(var.device_groups)
  # device_group = each.value
  # rulebase     = "pre-rulebase"
  device_group = "aks-dg"

  rule {
    name                  = "Allow DNS service"
    description           = "Allow access to the kube-dns service"
    source_zones          = ["any"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = [panos_panorama_address_group.kube_dns_svc.name]
    applications          = ["dns"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
    log_setting           = panos_panorama_log_forwarding_profile.cnseries_logs.name
  }

  rule {
    name                  = "Allow web frontend"
    description           = "Allow access to the web frontend"
    source_zones          = ["any"]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = [panos_panorama_address_group.web_frontend.name]
    applications          = ["web-browsing"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
    log_setting           = panos_panorama_log_forwarding_profile.cnseries_logs.name
  }

  rule {
    name                  = "Allow redis backend"
    description           = "Allow access to the redis backend"
    source_zones          = ["any"]
    source_addresses      = [panos_panorama_address_group.web_frontend.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = [panos_panorama_address_group.redis_backend.name]
    applications          = ["redis"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
    log_setting           = panos_panorama_log_forwarding_profile.cnseries_logs.name
  }

  rule {
    name                  = "Allow redis sync"
    description           = "Allow redis slaves to sync with the redis master"
    source_zones          = ["any"]
    source_addresses      = [panos_panorama_address_group.redis_slave_svc.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = ["any"]
    destination_addresses = [panos_panorama_address_group.redis_master_svc.name]
    applications          = ["any"]
    services              = [panos_panorama_service_object.redis_6379.name]
    categories            = ["any"]
    action                = "allow"
    log_setting           = panos_panorama_log_forwarding_profile.cnseries_logs.name
  }
}
