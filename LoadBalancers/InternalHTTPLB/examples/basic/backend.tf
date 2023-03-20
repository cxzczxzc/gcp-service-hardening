#To test locally, you will need to comment out this file so backend in TFC is not referenced.

terraform {
  backend "remote" {
    organization = "dnb-core"

    workspaces {
      name = "terratest-terraform-google-dnb_gcp_http_internal_lb"
    }
  }
}
