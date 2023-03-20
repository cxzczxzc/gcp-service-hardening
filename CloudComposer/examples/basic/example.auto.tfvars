pod_ip_allocation_range_name           = "terratest-modules127c1f2e744f8-secondary-pods"
service_ip_allocation_range_name       = "terratest-modules127c1f2e744f8-secondary-services"
region                                 = "us-east4"
environment_size                       = "ENVIRONMENT_SIZE_SMALL"
network                                = "nonprod-shared-trust"
subnetwork                             = "terratest-modules127c1f2e744f8"
project_id                             = "terratest-modules127c1f2e744f8"
service_account_name                   = "composer-service-account"
composer_env_name                      = "composer"
network_project_id                     = "host-networking51299c9b7bc30c5"
cloud_composer_network_ipv4_cidr_block = "172.31.243.0/24"
cloud_sql_ipv4_cidr                    = "10.255.228.0/24"
additional_network_tags                = ["smtp-out"]
pypi_packages = {
  pandas = ">=1.1.1"
}
airflow_config_overrides = {
  api-enable_experimental_api = "True"
  api-auth_backend            = "airflow.api.auth.backend.default"
}
env_variables = {
  bucket = "test"
}
