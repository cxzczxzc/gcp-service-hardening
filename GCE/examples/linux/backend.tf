terraform {
  backend "remote" {
    organization = "dnb-core"

    workspaces {
      name = "terraform-google-dnb_gcp_compute_engine_linux"
    }
  }
}
