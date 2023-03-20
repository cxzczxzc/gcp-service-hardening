terraform {
  required_version = ">= 1.1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.27.0, <5.0"
    }

  }
}