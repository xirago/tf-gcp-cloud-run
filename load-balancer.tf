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

resource "google_compute_target_http_proxy" "this" {
  name    = "${var.name_prefix}-cloud-run"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "${var.name_prefix}-default-map"
  default_service = google_compute_backend_service.cloud_run.self_link
}

resource "google_compute_global_forwarding_rule" "http" {
  name                  = "proxy-cloud-run"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.this.id
  ip_address            = google_compute_global_address.this.id
}
