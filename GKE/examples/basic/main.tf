module "module_under_test" {
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
  //depends_on                = [module.gcp-network]
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

# VPC
// module "gcp-network" {
//   source  = "terraform-google-modules/network/google"
//   version = ">= 4.0.1, < 5.0.0"
//
//   project_id   = var.project_id
//   network_name = var.network
//
//   subnets = [
//     {
//       subnet_name           = var.subnet
//       subnet_ip             = "10.250.128.0/23"
//       subnet_region         = var.region
//       subnet_private_access = "true"
//     },
//   ]
//
//   secondary_ranges = {
//     (var.subnet) = [
//       {
//         range_name    = var.secondary_subnet_pods
//         ip_cidr_range = "192.168.1.0/24"
//       },
//       {
//         range_name    = var.secondary_subnet_services
//         ip_cidr_range = "192.168.2.0/24"
//       },
//     ]
//   }
// }
