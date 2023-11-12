# Global load-balancer resources for Cloud Run Service
# Ref: https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-serverless

resource "google_compute_global_address" "this" {
  name       = "${var.name_prefix}-glb-ip"
  ip_version = "IPV4"
}

resource "google_compute_backend_service" "cloud_run" {
  name                  = "${var.name_prefix}-cloud-run"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  log_config {
    enable = true
  }

  backend {
    group = google_compute_region_network_endpoint_group.cloud_run.id
  }
}

resource "google_compute_target_https_proxy" "this" {
  name             = "${var.name_prefix}-cloud-run"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_ssl_certificate.self_signed.id]
}

resource "google_compute_url_map" "default" {
  name            = "${var.name_prefix}-default-map"
  default_service = google_compute_backend_service.cloud_run.self_link
}

resource "google_compute_global_forwarding_rule" "https" {
  name                  = "tls-proxy-cloud-run"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.this.id
  ip_address            = google_compute_global_address.this.id
}
