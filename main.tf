# Define regional Cloud Run Service & Network Endpoint Group
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service

resource "google_cloud_run_v2_service" "this" {
  name     = "${var.name_prefix}-vm-demo"
  location = var.region

  # Restrict ingress to load balancer only
  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    containers {
      image = var.run_container_url
    }

    scaling {
      # Set min count to 1 to prevent spurious cold starts
      min_instance_count = 1
      max_instance_count = var.run_max_instance_count
    }
  }
}

resource "google_compute_region_network_endpoint_group" "cloud_run" {
  name                  = "cloud-run"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = google_cloud_run_v2_service.this.name
  }
}
