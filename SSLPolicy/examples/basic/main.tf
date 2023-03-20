module "module_under_test" {
  source              = "../.."
  project_id          = var.project_id
  region              = var.region
  ssl_policy_name     = var.ssl_policy_name
  ssl_profile         = var.ssl_profile
  ssl_min_tls_version = var.ssl_min_tls_version
  ssl_policy_global   = var.ssl_policy_global
}