terraform {
  backend "remote" {
    organization = "dnb-core"

    workspaces {
      name = "terratest-tf-google-dnb_gcp_cloud_storage-production-grade"
    }
  }
}
