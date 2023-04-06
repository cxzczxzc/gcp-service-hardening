#To test locally, you will need to comment out this file so backend in TFC is not referenced.

terraform {
  backend "remote" {
    organization = "dnb-core"

    workspaces {
      name = "terraform-google-dnb_gcp_project_cloudkms-terratest"
    }
  }
}
