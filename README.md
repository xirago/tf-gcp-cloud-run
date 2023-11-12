# tf-gcp-cloud-run

## What

Terraform repository which defines a GCP Cloud Run service with a public Global Load Balancer

## Why

To demonstrate an `hello world` Cloud Run service with a global public load balancer

## How

 TODO: Add deployment steps

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.6.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~>5.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_v2_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_compute_backend_service.cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_address.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.http](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_region_network_endpoint_group.cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |
| [google_compute_target_http_proxy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A task designation to be used a prefix in resource naming | `string` | `"cloud-run-public"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID to be used for resource deployment | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region to be used for deployment | `string` | n/a | yes |
| <a name="input_run_container_url"></a> [run\_container\_url](#input\_run\_container\_url) | URL of the Container image in Google Container Registry or Google Artifact Registry | `string` | `"us-docker.pkg.dev/cloudrun/container/hello"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudrun_service_uri"></a> [cloudrun\_service\_uri](#output\_cloudrun\_service\_uri) | n/a |
<!-- END_TF_DOCS -->
