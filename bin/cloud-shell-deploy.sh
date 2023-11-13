#!/bin/bash
# This script expects to be executed inside GCP Cloud Shell

set -euo pipefail

# Set some helper vars
RED="\033[1;31m"
GREEN="\\033[1;32m"
YELLOW="\\033[1;93m"
RESET="\\033[0m"

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

