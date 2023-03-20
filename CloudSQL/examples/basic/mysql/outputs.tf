output "project_id" {
  value       = var.project_id
  description = "The project to run tests against"
}

output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.mysql_test.name
}

output "mysql_conn" {
  value       = module.mysql_test.mysql_conn
  description = "The connection name of the master instance to be used in connection strings"
}

output "mysql_user_pass" {
  value       = module.mysql_test.mysql_user_pass
  sensitive   = true
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = module.mysql_test.public_ip_address
}