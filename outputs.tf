output "glb_load_balancer_url" {
  value = "https://${google_compute_global_address.this.address}"
}

output "hide_private_key" {
  value       = tls_private_key.this
  description = "Hide the generated private key for TLS cert."
  sensitive   = true
}
