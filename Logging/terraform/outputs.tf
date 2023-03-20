# This is handled by DevX and set in TF Cloud
output "project_id" {
  value = var.project_id
}

# Service account data
output "cribl_service_account" {
  value = google_service_account.cribl_service_account.email
}

output "cribl_service_account_unique_id" {
  value = google_service_account.cribl_service_account.unique_id
}

output "cribl_service_account_id" {
  value = google_service_account.cribl_service_account.id
}

# this seems to be identical to id
output "cribl_service_account_name" {
  value = google_service_account.cribl_service_account.name
}

output "cribl_service_account_key_id" {
  value = google_service_account_key.cribl_auth_key2.id
}

# this seems to be identical to id
output "cribl_service_account_key_name" {
  value = google_service_account_key.cribl_auth_key2.name
}

output "cribl_secret_template" {
  value = <<EOT
{
  "type": "service_account",
  "project_id": "${var.project_id}",
  "private_key_id": "0101010101",
  "private_key": "-----KEY-----\n",
  "client_email": "${google_service_account.cribl_service_account.email}",
  "client_id": "${google_service_account.cribl_service_account.unique_id}",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/${urlencode(google_service_account.cribl_service_account.email)}"
}
EOT
}

# Admin logs pipeline
output "admin_topic_id" {
  value = module.logs-admin.topic_id
}

output "admin_subscription_id" {
  value = module.logs-admin.subscription_id
}

output "admin_sink_id" {
  value = google_logging_organization_sink.organization_log_sink_admin.id
}

output "admin_sink_writer_id" {
  value = google_logging_organization_sink.organization_log_sink_admin.writer_identity
}

# Network logs pipeline
output "network_topic_id" {
  value = module.logs-network.topic_id
}

output "network_subscription_id" {
  value = module.logs-network.subscription_id
}

output "network_sink_id" {
  value = google_logging_organization_sink.organization_log_sink_network.id
}

output "network_sink_writer_id" {
  value = google_logging_organization_sink.organization_log_sink_network.writer_identity
}

# prod/non-prod PubSub

output "prod_topic_id" {
  value = module.logs-prod.topic_id
}

output "prod_subscription_id" {
  value = module.logs-prod.subscription_id
}

output "nonprod_topic_id" {
  value = module.logs-nonprod.topic_id
}

output "nonprod_subscription_id" {
  value = module.logs-nonprod.subscription_id
}
