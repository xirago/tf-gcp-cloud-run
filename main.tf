resource "google_cloud_run_v2_service" "this" {
  name     = "${var.name_prefix}-vm-demo"
  location = var.region

  # TODO: Remove unfiltered PUBLIC access
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.run_container_url
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
