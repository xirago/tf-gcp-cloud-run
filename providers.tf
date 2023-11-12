terraform {
  required_version = "~>1.6.0"

  # GCS backend config is env. specific and should be defined in an external file
  # https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration
  backend "gcs" {}

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>5.5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region

  default_labels = {
    tf-repo = "xirago_tf-gcp-cloud-run"
    summary = var.name_prefix
  }
}
