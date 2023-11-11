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
  default     = "vm-task"
  description = "A task designation to be used a prefix in resource naming"
}
