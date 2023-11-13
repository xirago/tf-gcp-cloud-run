#!/bin/bash
# This script expects to be executed inside GCP Cloud Shell

set -euo pipefail

# Set some helper vars
RED="\033[1;31m"
GREEN="\\033[1;32m"
YELLOW="\\033[1;93m"
RESET="\\033[0m"

RUN_ENVIRONMENT=$(gcloud config get metrics/environment)
RND_SUFFIX=$(($RANDOM))
BACKEND_FILE_PREFIX="./environments"

# Globals to be set later
GCP_PROJECT=""
GCS_BUCKET=""
BACKEND_FILE_PATH=""
TFVARS_FILE_PATH=""

# Functions
function log_step {
  echo -e "${GREEN}$*${RESET}"
}

function log_info {
  echo -e "${YELLOW}INFO: $*${RESET}"
}

function log_error {
  echo -e "${RED}ERROR: $*${RESET}"
}

# Check for Cloud Shell specific config option
function check_cloudshell {
  if [[ $RUN_ENVIRONMENT != "devshell" ]]; then
    log_error "This script expects to be executed in GCP CLoud Shell"
    log_info "For details see: https://cloud.google.com/shell/docs/launching-cloud-shell#launch_from_the"
    exit
  else
    GCP_PROJECT=$GOOGLE_CLOUD_PROJECT
  fi
}

# Check for pre-existing tfstate file & create GCS bucket as needed
function check_statefile {
  # Check explicitly for the known bucket prefix & state file
  result=$(gcloud storage ls gs://tf-state-*/tf-gcp-cloud-run/*.tfstate || echo "")

  if [[ -z $result ]]; then
    log_info "Could not find pre-existing tfstate file. Creating a new GCS bucket"
    create_tfstate_bucket
  else
    log_step "Found pre-existing tfstate file. Skipping bucket creation"
  fi
}

# Create a bucket name with random suffix & set global var.for later use
function create_tfstate_bucket {
  bucket_name="tf-state-$RND_SUFFIX"

  gcloud storage buckets create gs://$bucket_name --public-access-prevention
  log_step "Bucket Created: gs://$bucket_name"

  # Only set if bucket is created (therefore first run)
  GCS_BUCKET="$bucket_name"
}

# Check for a local TF remote backend config and create if needed
function check_local_backend_config {
  BACKEND_FILE_PATH="$BACKEND_FILE_PREFIX/$GCP_PROJECT/$GCP_PROJECT.backend.hcl"

  if [[ -f $BACKEND_FILE_PATH ]]; then
    log_step "Backend config found"
  else
    log_info "Local backend configuration not found where expected"
    log_step "Creating terraform remote backend config"

    # Create local environments folder for project specific backend & variables (if required)
    mkdir -p ./$BACKEND_FILE_PREFIX/$GCP_PROJECT

    # Set GCS bucket and prefix for remote state config
    echo -e "bucket = \"$GCS_BUCKET\"" >$BACKEND_FILE_PATH
    echo -e "prefix = \"tf-gcp-cloud-run\"" >>$BACKEND_FILE_PATH
    log_step "Created $BACKEND_FILE_PATH with remote backend config"
  fi
}

function check_project_vars_file {

  # Set global for tfvars file path
  TFVARS_FILE_PATH="$BACKEND_FILE_PREFIX/$GCP_PROJECT/$GCP_PROJECT.tfvars"

  if [[ -f $TFVARS_FILE_PATH ]]; then
    log_step "Existing tfvars file found. Skipping creating one"
    return
  else
    # Write out only required tf variable
    log_step "Created $TFVARS_FILE_PATH with project specific minimal project specific variables"
    echo -e "project_id = \"$GCP_PROJECT\"" > $TFVARS_FILE_PATH
  fi
}

function enable_gcp_services {
  # Assuming these GCP APIs have not been enabled
  log_step "Enabling GCP APIs for initial deployment... This may take a few minutes"
  gcloud services enable compute.googleapis.com run.googleapis.com certificatemanager.googleapis.com iam.googleapis.com
  log_step "GCP APIs enabled"
}

function tf_initialise {
  log_step "Removing any previous local terraform state"
  rm -rf ./.terraform ./*.tfstate

  log_step "Running 'terraform init'"
  terraform init --backend-config $BACKEND_FILE_PATH
}

function tf_show_plan {

  # Set project_id from Cloud Shell config
  export TF_VAR_project_id=$GCP_PROJECT

  terraform plan -out script.plan
}

# Main script entrypoint

# Pre-flight checks
check_cloudshell
check_statefile
check_local_backend_config
check_project_vars_file

# Ensure GCP APIs are enabled for first tf init
if [[ -n $GCS_BUCKET ]]; then
  enable_gcp_services
else
  log_step "Running terraform init with existing backend config"
fi

# Initialise terraform with GCS backend
tf_initialise

# Run terraform plan & save output locally
tf_show_plan

# Require user confirmation to deploy changes!
log_step "Type ${YELLOW}DEPLOY${GREEN} to confirm deployment:"
read -p "Enter DEPLOY to continue: " user_confirm

# If confirmed deploy or exit
if [[ $user_confirm == "DEPLOY" ]]; then
  log_step "Thanks! Applying terraform plan"
  terraform apply script.plan
else
  log_error "Ok, not applying plan"
  log_info "Please re-run deploy script to create a new plan or apply the plan manually"
  exit
fi

log_step "Deployment completed"
log_info "GCS remote backend config is: $BACKEND_FILE_PATH"
log_info "Project specific variables file is: $TFVARS_FILE_PATH"
