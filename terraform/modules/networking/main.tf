resource "google_project_service" "dns" {
  project = var.project_id

  service = "dns.googleapis.com"
}

resource "google_compute_network" "custom_network" {
  name           = "${terraform.workspace}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "bastion" {
  name          = "${terraform.workspace}-bastion-subnet"
  region        = var.bastion_region
  network       = google_compute_network.custom_network.self_link
  ip_cidr_range = var.bastion_cidr
}

resource "google_compute_subnetwork" "private" {
  name          = "${terraform.workspace}-private-subnet"
  region        = var.private_region
  network       = google_compute_network.custom_network.self_link
  ip_cidr_range = var.private_cidr
}
resource "google_compute_firewall" "bastion-Http-ssh" {
  name    = "${terraform.workspace}-bastion-firewall"
  network = google_compute_network.custom_network.self_link

  # Allow rules
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  
  allow {
    protocol = "icmp"
  }

  target_tags = [var.bastion_network_tags] # Apply to VMs with this tag
  source_ranges = ["0.0.0.0/0"]  # Allow traffic from any source
}

resource "google_compute_firewall" "private-ssh" {
  name    = "${terraform.workspace}-private-firewall"
  network = google_compute_network.custom_network.self_link

  # Allow rules
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  allow {
    protocol = "icmp"
  }

  target_tags = [var.private_network_tags] # Apply to VMs with this tag
  source_ranges = ["10.0.1.0/24"]  # Allow traffic from any source
}

output "network_self_link" {
  value = google_compute_network.custom_network.self_link
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.bastion.self_link
}
