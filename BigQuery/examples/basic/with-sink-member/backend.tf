terraform {
  backend "remote" {

    organization = "dnb-core"
    workspaces {
      name = "terraform-google-dnb_gcp_bigquery_2ndtest"
    }

  }
}
