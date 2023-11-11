variable "project_id" {
  type        = string
  description = "GCP Project ID to be used for resource deployment"
}

variable "region" {
  type        = string
  description = "GCP region to be used for deployment"
}
variable "name_prefix" {
  type        = string
  default     = "cloud-run-public"
  description = "A task designation to be used a prefix in resource naming"
}

variable "run_container_url" {
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
  description = "URL of the Container image in Google Container Registry or Google Artifact Registry"
}
