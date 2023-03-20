output "region" {
  description = "Name of a region"
  value       = var.region
}

output "tls_version" {
  description = "Minimum TLS version"
  value       = var.ssl_min_tls_version
}

output "ssl_policy_name" {
  description = "Name of SSL Policy"
  value       = var.ssl_policy_name
}