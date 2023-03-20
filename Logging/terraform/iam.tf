resource "google_service_account" "cribl_service_account" {
  account_id   = var.service_account
  display_name = var.service_account
  description  = "Service account used by Cribl SaaS"
}

# 8/5/2022 - removing uploaded key - not needed.
#            Generated key need to be pushed to HCP Vault
# This needs keys
# resource "google_service_account_key" "cribl_auth_key" {
#   service_account_id = google_service_account.cribl_service_account.name
#   # public_key_type    = "TYPE_X509_PEM_FILE"
#   # base64 encoded X509_PEM, conflicts with *_key_type
#   # https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-accounts-upload-rest
#   public_key_data     = filebase64(var.svc_pub_key)   
# }

resource "google_service_account_key" "cribl_auth_key2" {
  service_account_id = google_service_account.cribl_service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# If generating key, it can be printed here, but this is not secure
# It needs to be sent to some secure vault and then transferred to the client
# output "private_key" {
#   value = nonsensitive(google_service_account_key.cribl_auth_key2.private_key)
# }

# not really useful, but can be printed out...
# output "public_key" {
#   value = google_service_account_key.cribl_auth_key.public_key
# }

output "public_key2" {
  value = google_service_account_key.cribl_auth_key2.public_key
}

