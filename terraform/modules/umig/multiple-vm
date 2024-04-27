module "networking" {
source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/networking"
}

module "service-account" {
source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/service-account"
}

resource "google_compute_instance" "vm" {
  count        = 3
  name         = "vm-server-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = module.networking.network_self_link
    subnetwork = module.networking.subnetwork_self_link

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    email  = module.service-account.svc_email
    scopes = ["cloud-platform"]
  }

  tags = ["vm-server-${count.index + 1}"]  # Add network tags

}

output "vm1_self_link" {
  value = google_compute_instance.vm[0].self_link
}

output "vm2_self_link" {
  value = google_compute_instance.vm[1].self_link
}

output "vm3_self_link" {
  value = google_compute_instance.vm[2].self_link
}
