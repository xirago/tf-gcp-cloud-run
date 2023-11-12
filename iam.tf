# Create GSA with permissions to invoke cloud run
# ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam

resource "google_service_account" "cloud_run" {
  account_id   = var.project_id
  display_name = "cloud-run-invoker"
}

data "google_iam_policy" "invoke_cloud_run" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.cloud_run.email}"
    ]
  }
}

# Bind Cloud Run service to GSA policy
resource "google_cloud_run_service_iam_policy" "this" {
  location = google_cloud_run_v2_service.this.location
  project  = google_cloud_run_v2_service.this.project
  service  = google_cloud_run_v2_service.this.name

  policy_data = data.google_iam_policy.invoke_cloud_run.policy_data
}
