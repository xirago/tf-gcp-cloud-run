resource "google_compute_global_address" "this" {
  name       = "${var.name_prefix}-glb-ip"
  ip_version = "IPV4"
}

