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

resource "google_compute_disk" "logging_disk" {
  name                      = "panorama-logging"
  type                      = "pd-standard"
  zone                      = var.panorama_zone
  size                      = 2000
  physical_block_size_bytes = 4096
}

resource "google_compute_instance" "panorama" {
  name                      = var.panorama_name
  zone                      = var.panorama_zone
  machine_type              = var.panorama_machine_type
  min_cpu_platform          = var.panorama_machine_cpu
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.panorama_image
    }
  }

  attached_disk {
    source      = google_compute_disk.logging_disk.self_link
    device_name = "logging"
    mode        = "READ_WRITE"
  }

  metadata = {
    serial-port-enable     = true
    block-project-ssh-keys = true
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = var.panorama_subnet
    access_config {
    }
  }
}
