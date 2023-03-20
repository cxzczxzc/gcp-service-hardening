terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.21.0, <5.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.21.0, <5.0"
    }

  }
  required_version = "~> 1.2.0"
}
