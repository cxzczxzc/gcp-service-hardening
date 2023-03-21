terraform {
  required_version = ">= 1.3.0" #verison upgrade

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.18.0"
    }
  }
}
