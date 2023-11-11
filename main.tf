resource "google_cloud_run_v2_service" "this" {
  name     = "vm-demo"
  location = var.region

  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
