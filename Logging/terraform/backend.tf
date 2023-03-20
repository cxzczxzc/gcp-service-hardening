terraform {
  cloud {
    organization = "dnb-core"
    workspaces {
      name = "dnb_gcp_central_logging"
    }
  }
  # backend "remote" {
  #   organization = "dnb-core"
  #   workspaces {
  #     name = "dnb_gcp_central_logging"
  #   }
  # }
}

