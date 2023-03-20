terraform {
  backend "remote" {
    organization = "dnb-core"

    workspaces {
      prefix = "devx-gcp-landingzone-drg"
    }
  }
}