output "region" {
  value = var.region
}

output "composer_env_name" {
  value       = module.module_under_test.composer_env_name
  description = "Name of the Cloud Composer Environment."
}

output "airflow_uri" {
  value       = module.module_under_test.airflow_uri
  description = "URI of the Apache Airflow Web UI hosted within the Cloud Composer Environment."
}