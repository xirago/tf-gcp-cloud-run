#
# Required variables
#

variable "project_id" {
  type        = string
  description = "GCP Project ID to be used for resource deployment"
}

#
# Optional variables
#

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region to be used for deployment"
}

variable "run_max_instance_count" {
  type        = number
  default     = 5
  description = "Maximum number of serving instances that this resource should have"
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

variable "tls_cert_domains" {
  type        = list(string)
  default     = ["www.self-signed-tls.uk"]
  description = "A list of DNS names to be added to the TLS certificate. The Common Name will be set to the first string entry"
}
