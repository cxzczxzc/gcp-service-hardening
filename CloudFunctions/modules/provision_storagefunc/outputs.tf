output "region" {
  value = var.region
}

output "service_account_email" {
  value = google_cloudfunctions_function.storagefunction.service_account_email
}

output "cloudfunction_id" {
  value = google_cloudfunctions_function.storagefunction.id
}