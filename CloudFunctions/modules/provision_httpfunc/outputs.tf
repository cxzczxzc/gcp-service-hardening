output "region" {
  value = var.region
}

output "service_account_email" {
  value = google_cloudfunctions_function.httpfunction.service_account_email
}

output "cloudfunction_id" {
  value = google_cloudfunctions_function.httpfunction.id
}

output "cloudfunction_https_trigger_url" {
  value = google_cloudfunctions_function.httpfunction.https_trigger_url
}
