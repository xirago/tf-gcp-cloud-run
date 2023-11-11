resource "google_cloud_run_v2_service" "this" {
  name     = "${var.name_prefix}-vm-demo"
  location = var.region

  # TODO: Remove unfiltered PUBLIC access
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.run_container_uri
    }
  }
}
