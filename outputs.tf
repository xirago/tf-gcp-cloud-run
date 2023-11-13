output "cloud_run_url" {
  value       = google_cloud_run_v2_service.this.uri
  description = "URI of the Cloud Run service. This is needed to set the audience for token generation"
}

output "glb_load_balancer_url" {
  value = "https://${google_compute_global_address.this.address}"
}

output "hide_private_key" {
  value       = tls_private_key.this
  description = "Hide the generated private key for TLS cert."
  sensitive   = true
}

output "gcp_service_account_email" {
  value       = google_service_account.cloud_run.email
  description = "Email ID of the GSA that can invoke Cloud Run service"
}
