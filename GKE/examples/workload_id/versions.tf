terraform {
  required_version = ">= 1.1.0"

  required_providers {
    // use minimum version pinning in modules. see https://www.terraform.io/docs/language/expressions/version-constraints.html#terraform-core-and-provider-versions
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.2"
    }
  }
}
