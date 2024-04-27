module "networking" {
source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/networking"
}

module "service-account" {
source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/service-account"
}

resource "google_compute_instance_template" "template" {
  name        = "${terraform.workspace}-template"
  description = "This template is used to create dev server instances."

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
  }

  network_interface {
    network = module.networking.network_self_link
    subnetwork = module.networking.subnetwork_self_link

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = module.service-account.svc_email
    scopes = ["cloud-platform"]
  }

  tags = ["web-server", "http-server"]  # Add network tags
}

output "template_self_link" {
  value = google_compute_instance_template.template.self_link
}
