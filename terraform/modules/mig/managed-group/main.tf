module "mig-template" {
  source = "/home/sumo1998sumanth/TERRAFORM-DEMO/terraform/modules/mig/mig-template"
}

resource "google_compute_health_check" "example_health_check" {
  name               = "${terraform.workspace}-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  tcp_health_check {
    port = 80
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "${terraform.workspace}-instance-group-manager"
  base_instance_name = "${terraform.workspace}-instance"
  zone               = "us-central1-f"
  target_size        = "2"

  version {
    name              = "v1"
    instance_template = module.mig-template.template_self_link
  }
}

resource "google_compute_autoscaler" "example_autoscaler" {
  name                  = "${terraform.workspace}-example-autoscaler"
  zone = "us-central1-f"  # Specify the zone where the autoscaler will be located
  target                = google_compute_instance_group_manager.instance_group_manager.self_link
  autoscaling_policy {
    min_replicas = 2
    max_replicas = 4
  }

}
