terraform {
  backend "remote" {
    organization = "dnb-core"

    workspaces {
      name = "terraform-google-dnb_gke-workload-id-terratest"
    }
  }
}
