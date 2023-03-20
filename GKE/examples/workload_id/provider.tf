provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
  host                   = "https://${module.private_gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.private_gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.private_gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.private_gke.ca_certificate)
  }
}

provider "time" {}
