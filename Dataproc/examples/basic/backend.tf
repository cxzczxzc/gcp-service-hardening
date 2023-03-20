terraform {
  backend "remote" {
    organization = "dnb-core"

    workspaces {
      name = "terratest-terraform-google-dnb_gcp_dataproc"
    }
  }
}
