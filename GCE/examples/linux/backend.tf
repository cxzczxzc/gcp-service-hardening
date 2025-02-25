terraform {
  backend "remote" {
    organization = "<ORG_NAME>"

    workspaces {
      name = "<TFC_WORKSPACE_NAME>"
    }
  }
}
