locals {
  keys_by_name = zipmap(var.keys, var.prevent_destroy ? slice(google_kms_crypto_key.key[*].id, 0, length(var.keys)) : slice(google_kms_crypto_key.key_ephemeral[*].id, 0, length(var.keys)))
}

resource "google_kms_key_ring" "key_ring" {
  name     = var.keyring
  project  = var.project_id
  location = var.location
}

resource "google_kms_crypto_key" "key" {
  count           = var.prevent_destroy ? length(var.keys) : 0
  name            = var.keys[count.index]
  key_ring        = google_kms_key_ring.key_ring.id
  purpose         = var.purpose
  rotation_period = var.key_rotation_period
  #https://github.com/bridgecrewio/checkov/issues/4862
  #rotation_period = (contains(["ASYMMETRIC_SIGN", "ASYMMETRIC_DECRYPT"], var.purpose) ? null : var.key_rotation_period)

  lifecycle {
    prevent_destroy = true
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key" "key_ephemeral" {
  count           = var.prevent_destroy ? 0 : length(var.keys)
  name            = var.keys[count.index]
  key_ring        = google_kms_key_ring.key_ring.id
  purpose         = var.purpose
  rotation_period = contains(["ASYMMETRIC_SIGN", "ASYMMETRIC_DECRYPT"], var.purpose) ? null : var.key_rotation_period

  lifecycle {
    prevent_destroy = false
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key_iam_binding" "owners" {
  count         = length(var.set_owners_for)
  role          = "roles/owner"
  crypto_key_id = local.keys_by_name[var.set_owners_for[count.index]]
  members       = compact(split(",", var.owners[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "decrypters" {
  count         = length(var.set_decrypters_for)
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = local.keys_by_name[var.set_decrypters_for[count.index]]
  members       = compact(split(",", var.decrypters[count.index]))
}

resource "google_kms_crypto_key_iam_binding" "encrypters" {
  count         = length(var.set_encrypters_for)
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = local.keys_by_name[element(var.set_encrypters_for, count.index)]
  members       = compact(split(",", var.encrypters[count.index]))
}

# resource "null_resource" "crypto_key_type_validation" {

#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   lifecycle {
#     precondition {
#       condition     = contains(["ASYMMETRIC_SIGN", "ASYMMETRIC_DECRYPT"], var.purpose) ? var.key_rotation_period = null : true
#       error_message = "Validation: For Asymmetric Keys Rotation should be manual."
#     }
#   }
# }