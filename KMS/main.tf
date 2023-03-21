resource "google_kms_key_ring" "key_ring" {
  name     = var.keyring
  project  = var.project_id
  location = var.location
}
# for creating asymmetric keys within a given keyring
resource "google_kms_crypto_key" "asymmetric_key" {
  for_each = var.asymmetric_keys
  key_ring = google_kms_key_ring.key_ring.id

  name    = each.value["asymmetric_key_name"]
  purpose = each.value["asymmetric_key_purpose"]

  lifecycle {
    prevent_destroy = true
  }

  version_template {
    algorithm        = each.value["asymmetric_key_algorithm"]
    protection_level = each.value["asymmetric_key_protection_level"]
  }

  labels = each.value["labels"]
}
# for creating symmetric keys within a given keyring
resource "google_kms_crypto_key" "symmetric_key" {
  for_each = var.symmetric_keys
  key_ring = google_kms_key_ring.key_ring.id

  name    = each.value["symmetric_key_name"]
  purpose = each.value["symmetric_key_purpose"]
  lifecycle {
    prevent_destroy = true
  }
  version_template {
    algorithm        = each.value["symmetric_key_algorithm"]
    protection_level = each.value["symmetric_key_protection_level"]
  }

  labels = each.value["labels"]
}
# for creating symmetric keys within a given keyring with an autorotate schedule
# automatic rotation of keys is only possible when the key purpose is ENCRYPT_DECRYPT
# key purpose ENCRYPT_DECRYPT only works with the algorithm GOOGLE_SYMMETRIC_ENCRYPTION
resource "google_kms_crypto_key" "symmetric_key_with_rotation_period" {
  for_each = var.symmetric_keys_auto_rotate
  key_ring = google_kms_key_ring.key_ring.id

  name            = each.value["symmetric_key_name"]
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = each.value["symmetric_key_rotation_period"]
  lifecycle {
    prevent_destroy = true
  }
  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = each.value["symmetric_key_protection_level"]
  }

  labels = each.value["labels"]
}



