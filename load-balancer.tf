resource "google_compute_global_address" "this" {
  name       = "${var.name_prefix}-glb-ip"
  ip_version = "IPV4"
}

resource "google_compute_backend_service" "cloud_run" {
  name                  = "${var.name_prefix}-cloud_run"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.cloud_run.id
  }
}

