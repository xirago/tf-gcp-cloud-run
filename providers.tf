terraform {
  required_version = "~>1.6.0"

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
