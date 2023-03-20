terraform {
  required_version = ">= 1.1.0"

  required_providers {
    // use minimum version pinning in modules. see https://www.terraform.io/docs/language/expressions/version-constraints.html#terraform-core-and-provider-versions
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7"
    }

    infoblox = {
      source  = "infobloxopen/infoblox"
      version = "2.0.1"
    }

  }
}
