# Create an RSA private key and a self-signed TLS certificate

resource "google_compute_ssl_certificate" "self_signed" {
  name_prefix = "${var.name_prefix}-cloud-run-glb-"
  certificate = tls_self_signed_cert.this.cert_pem
  private_key = tls_private_key.this.private_key_pem

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "this" {
  private_key_pem = tls_private_key.this.private_key_pem

  # Certificate expires after 30 days
  validity_period_hours = 24

  # Generate a new certificate if Terraform is run within 7
  # days of the certificate's expiration time.
  early_renewal_hours = 23

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = var.tls_cert_domains

  # Add global IP Address to self signed cert
  ip_addresses = [google_compute_global_address.this.address]

  subject {
    # Use 1st string in list as CN & ORG
    common_name  = var.tls_cert_domains[0]
    organization = var.tls_cert_domains[0]
  }
}
