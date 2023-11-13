# tf-gcp-cloud-run

## What

Terraform repository that defines a GCP Cloud Run service with a public Global Load Balancer with access limited to an authorised Google Service Account.

Terraform & supporting code can be deployed to multiple Google Projects, but expects only a single deployment in a single project.

Terraform state is stored remotely in a GCS bucket in the same project.

Global load balancer is terminated with a self signed TLS certificate, as no matching DNS domain is defined. This can be upgraded to a Google managed (and signed) certificate when required.

Cloud Run endpoint access is restricted:

- Ingress traffic is limited to [internal load balancer traffic](https://cloud.google.com/run/docs/securing/ingress#settings) only
- IAM authenticated access granted only to a managed Google Service Account. To leverage this account to access the endpoint [see below](#).

## Why

To demonstrate an `hello world` Cloud Run service with a global public load balancer with (relatively) secure access via Google Service Account.

As this repository is public, no private or sensitive information should be hosted in it, this includes variables values.

## How

### Deploying this configuration

A [wrapper script](bin/cloud-shell-deploy.sh) has been provided to simplify the initial configuration and deployment of this terraform code and allow for a single command deployment.

#### Pre-requisites

- **The wrapper script expects to be executed in Google Cloud Shell**

#### Deployment steps

1. Open a [Google Cloud Console](https://console.cloud.google.com) and select (or create) a GCP project for this deployment
2. Open a [Google Cloud Shell](https://cloud.google.com/shell/docs/launching-cloud-shell) terminal session
3. In the terminal run the following commands to clone this repository and execute the script:

```bash
git clone https://github.com/xirago/tf-gcp-cloud-run.git

# Change into repository root folder
cd tf-gcp-cloud-run

# Execute wrapper script from root folder
./bin/cloud-shell-deploy.sh
```

The script will run some pre-flight checks and if needed:

- Create a GCS bucket for remote state storage
- Create a local state backend file configured for the GCS bucket
- Create a project specific variable file for terraform to use
- Run a `terraform init` with the GCS backend config file
- Run a `terraform plan` with the project specific `tfvars` file
- Request confirmation of the planned changes



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.6.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~>5.5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~>4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.5.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service_iam_policy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_cloud_run_v2_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_compute_backend_service.cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_address.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_region_network_endpoint_group.cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |
| [google_compute_ssl_certificate.self_signed](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_certificate) | resource |
| [google_compute_target_https_proxy.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_service_account.cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [google_iam_policy.invoke_cloud_run](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A task designation to be used a prefix in resource naming | `string` | `"cloud-run-public"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID to be used for resource deployment | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region to be used for deployment | `string` | `"us-central1"` | no |
| <a name="input_run_container_url"></a> [run\_container\_url](#input\_run\_container\_url) | URL of the Container image in Google Container Registry or Google Artifact Registry | `string` | `"us-docker.pkg.dev/cloudrun/container/hello"` | no |
| <a name="input_run_max_instance_count"></a> [run\_max\_instance\_count](#input\_run\_max\_instance\_count) | Maximum number of serving instances that this resource should have | `number` | `5` | no |
| <a name="input_tls_cert_domains"></a> [tls\_cert\_domains](#input\_tls\_cert\_domains) | A list of DNS names to be added to the TLS certificate. The Common Name will be set to the first string entry | `list(string)` | <pre>[<br>  "www.self-signed-tls.uk"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_run_url"></a> [cloud\_run\_url](#output\_cloud\_run\_url) | URI of the Cloud Run service. This is needed to set the audience for token generation |
| <a name="output_gcp_service_account_email"></a> [gcp\_service\_account\_email](#output\_gcp\_service\_account\_email) | Email ID of the GSA that can invoke Cloud Run service |
| <a name="output_glb_load_balancer_url"></a> [glb\_load\_balancer\_url](#output\_glb\_load\_balancer\_url) | n/a |
| <a name="output_hide_private_key"></a> [hide\_private\_key](#output\_hide\_private\_key) | Hide the generated private key for TLS cert. |
<!-- END_TF_DOCS -->
