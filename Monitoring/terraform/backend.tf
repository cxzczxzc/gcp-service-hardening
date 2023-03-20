terraform {
  cloud {
    organization = "dnb-core"
    workspaces {
      tags = ["devx-bootstrapped"]
    }
  }
}

