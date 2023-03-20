locals {
  services = toset(concat(local.activate_apis))
  activate_apis = [
    "secretmanager.googleapis.com"
  ]
}

resource "google_secret_manager_secret" "secret" {
  project   = var.project_id
  secret_id = var.secret_name
  labels    = var.labels
  replication {
    dynamic "user_managed" {
      for_each = length(var.replication) > 0 ? [1] : []
      content {
        dynamic "replicas" {
          for_each = var.replication
          content {
            location = replicas.key
            dynamic "customer_managed_encryption" {
              for_each = toset(compact([replicas.value != null ? lookup(replicas.value, "kms_key_name") : null]))
              content {
                kms_key_name = customer_managed_encryption.value
              }
            }
          }
        }
      }
    }
    automatic = length(var.replication) > 0 ? null : true
  }
}

# Create a random value for secret
resource "random_password" "secret" {
  length      = 16
  upper       = true
  min_upper   = 3
  lower       = true
  min_lower   = 2
  numeric     = true
  min_numeric = 3
  special     = false
}

# Store actual secret as the latest version if it has been provided.
resource "google_secret_manager_secret_version" "secret" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = length(var.secret_data) > 0 ? var.secret_data : random_password.secret.result
}

# Allow the supplied accounts to read the secret value from Secret Manager
# from accounts that were granted the role outside this module.
resource "google_secret_manager_secret_iam_member" "secret" {
  for_each  = toset(var.accessors)
  project   = var.project_id
  secret_id = google_secret_manager_secret.secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value
}