module "private_gke" {
  source = "../.."

  project_id                = var.project_id
  region                    = var.region
  cluster_name              = var.cluster_name
  network                   = var.network
  subnet                    = var.subnet
  secondary_subnet_pods     = var.secondary_subnet_pods
  secondary_subnet_services = var.secondary_subnet_services
  service_account           = var.service_account
  node_pools                = var.node_pools

  enable_http_lb = true
}
