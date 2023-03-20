output "my_test_region" {
  value = var.region
}

output "secret_name" {
  value       = module.secret.secret_name
  description = "Name of the secret manager"
}
