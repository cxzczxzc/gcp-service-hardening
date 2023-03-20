provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "infoblox" {
  alias  = "infoblox"
  server = "infoblox.inf.dnb.com"
}