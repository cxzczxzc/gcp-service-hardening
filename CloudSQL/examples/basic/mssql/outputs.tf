output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.mssql_test.name
}

output "mssql_conn" {
  value       = module.mssql_test.mssql_conn
  description = "The connection name of the master instance to be used in connection strings"
}

output "mssql_user_pass" {
  value       = module.mssql_test.mssql_user_pass
  sensitive   = true
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}

output "private_ip_address" {
  description = "The private IP address assigned for the master instance"
  value       = module.mssql_test.private_ip_address
}