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

provider helm {}

resource "helm_release" "cn-series" {
  name       = "cn-series-deploy"
  repository = "https://stealthllama.github.io/cn-series-helm/"
  chart      = "cn-series"
  version    = "0.1.0"
  timeout    = 600

  depends_on = [var.helm_depends_on]

  // Panorma values
  set {
    name  = "panorama.ip"
    value = var.panorama_ip
    type  = "string"
  }

  set {
    name  = "panorama.authKey"
    value = var.panorama_auth_key
    type  = "string"
  }

  set {
    name  = "panorama.deviceGroup"
    value = "dev-dg"
    type  = "string"
  }

  set {
    name  = "panorama.template"
    value = "k8s-stack"
    type  = "string"
  }

  set {
    name  = "panorama.cgName"
    value = "rp-cg1"
    type  = "string"
  }

  // CNI values
  set {
    name  = "cni.image"
    value = "gcr.io/paloaltonetworksgcp-public/pan-cni"
    type  = "string"
  }

  set {
    name  = "cni.version"
    value = "1.0.0-b3"
    type  = "string"
  }

  set {
    name  = "cni.binDir"
    value = "/home/kubernetes/bin"
    type  = "string"
  }

  set {
    name  = "cni.confName"
    value = "10-calico.conflist"
    type  = "string"
  }

  // DP values
  set {
    name  = "dp.image"
    value = "gcr.io/paloaltonetworksgcp-public/paloaltonetworks/panos_cn_ngfw"
    type  = "string"
  }

  set {
    name  = "dp.version"
    value = "9.2.0-b30"
    type  = "string"
  }

  set {
    name  = "dp.cpu"
    value = "1"
  }

  set {
    name  = "dp.mem"
    value = "2.25Gi"
    type  = "string"
  }

  // MP values
  set {
    name  = "mp.image"
    value = "gcr.io/paloaltonetworksgcp-public/paloaltonetworks/panos_cn_mgmt"
    type  = "string"
  }

  set {
    name  = "mp.version"
    value = "30"
    type  = "string"
  }

  set {
    name  = "mp.initImage"
    value = "gcr.io/paloaltonetworksgcp-public/pan-mgmt-init"
    type  = "string"
  }

  set {
    name  = "mp.initVersion"
    value = "1.0.0-b3"
    type  = "string"
  }

  set {
    name  = "mp.cpu"
    value = "4"
  }

  set {
    name  = "mp.mem"
    value = "4.0Gi"
    type  = "string"
  }

  // Firewall values
  set {
    name  = "firewall.failoverMode"
    value = "failopen"
    type  = "string"
  }

  set {
    name  = "firewall.operationMode"
    value = "daemonset"
    type  = "string"
  }

  set {
    name  = "firewall.serviceName"
    value = "pan-mgmt-svc"
    type  = "string"
  }

  // Service account values
  set {
    name  = "serviceAccount.create"
    value = "true"
    type  = "string"
  }
}
