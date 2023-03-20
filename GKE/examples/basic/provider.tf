provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "infoblox" {
  alias  = "infoblox"
  server = "infoblox.inf.dnb.com"
}


# leave this k8s provider outside of GKE module so that it can be re-used
provider "kubernetes" {
  host                   = "https://${module.module_under_test.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.module_under_test.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.module_under_test.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.module_under_test.ca_certificate)
  }
}