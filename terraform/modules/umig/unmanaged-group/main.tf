module "multiple-vm" {
  source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/umig/multiple-vm"
}

resource "google_compute_instance_group" "unmanaged_group" {
  name      = "${terraform.workspace}-unmanaged-group"
  zone      = "us-central1-a"
  instances = [
    module.multiple-vm.vm1_self_link,
    module.multiple-vm.vm2_self_link,
    module.multiple-vm.vm3_self_link,
  ]
}

# Define a health check for the load balancer
resource "google_compute_http_health_check" "health_check" {
  name               = "${terraform.workspace}-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  request_path       = "/"
}

# Define a backend service for the load balancer
resource "google_compute_backend_service" "backend_service" {
  name                  = "${terraform.workspace}-backend-service"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  health_checks         = [google_compute_http_health_check.health_check.self_link]

  backend {
    group = google_compute_instance_group.unmanaged_group.self_link
  }
}

# Define a URL map for the load balancer
resource "google_compute_url_map" "url_map" {
  name            = "${terraform.workspace}--url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

# Define a target HTTP proxy for the load balancer
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "${terraform.workspace}--target-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

# Define a global forwarding rule for the load balancer
resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "${terraform.workspace}--forwarding-rule"
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}
