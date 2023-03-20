resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "module_under_test" {
  source                                 = "../.."
  project_id                             = var.project_id
  network                                = var.network
  region                                 = var.region
  composer_env_name                      = "${var.composer_env_name}-${random_string.suffix.result}"
  subnetwork                             = var.subnetwork
  service_account_name                   = var.service_account_name
  pod_ip_allocation_range_name           = var.pod_ip_allocation_range_name
  service_ip_allocation_range_name       = var.service_ip_allocation_range_name
  environment_size                       = var.environment_size
  network_project_id                     = var.network_project_id
  cloud_composer_network_ipv4_cidr_block = var.cloud_composer_network_ipv4_cidr_block
  cloud_sql_ipv4_cidr                    = var.cloud_sql_ipv4_cidr
  pypi_packages                          = var.pypi_packages
  airflow_config_overrides               = var.airflow_config_overrides
  env_variables                          = var.env_variables
  enable_ip_masq_agent                   = true
  image_version                          = "composer-2.0.31-airflow-2.3.3"
  additional_network_tags                = var.additional_network_tags
  scheduler = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 5
    count      = 2
  }
  web_server = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 5
  }
  worker = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 5
    min_count  = 2
    max_count  = 4
  }
}

