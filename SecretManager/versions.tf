terraform {
  required_version = ">= 1.1.0"

  required_providers {
    // use minimum version pinning in modules. see https://www.terraform.io/docs/language/expressions/version-constraints.html#terraform-core-and-provider-versions
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 4.18.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.18.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }

  }
}
