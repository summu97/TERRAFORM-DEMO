module "networking" {
source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/networking"
}

module "service-account" {
source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/service-account"
}

resource "google_compute_instance" "bastion" {
  name         = "${terraform.workspace}-bastion-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      labels = {
        my_label = "${terraform.workspace}"
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
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = module.service-account.svc_email
    scopes = ["cloud-platform"]
  }

  tags = [var.name]  # Add network tags

}


resource "google_compute_instance" "private" {
  name         = "${terraform.workspace}-private-vm"
  machine_type = var.machine_type_private
  zone         = var.zone_private

  boot_disk {
    initialize_params {
      image = var.image_private
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

  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = module.service-account.svc_email
    scopes = ["cloud-platform"]
  }

  tags = [var.name_private]  # Add network tags

}
