# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------
#output "secret_id" {
# value       = google_secret_manager_secret.secret.id
# description = "Id of the secret manager"
#}

output "secret_name" {
  value       = google_secret_manager_secret.secret.secret_id
  description = "Name of the secret manager"
}

