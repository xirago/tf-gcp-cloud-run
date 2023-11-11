terraform {
  required_version = "~>1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>5.5.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "google" {

}
