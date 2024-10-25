locals {
  key_decrypter_map = {
    for pair in setproduct(var.decrypters, var.set_decrypters_for_keys) :
    "${pair[0]}-${pair[1]}" => {
      decrypter = pair[0]
      key       = pair[1]
    }
  }

  key_ring_decrypter_map = {
    for pair in setproduct(var.decrypters, [var.keyring]) :
    "${pair[0]}-${pair[1]}" => {
      decrypter = pair[0]
      key_ring  = pair[1]
    }
  }

  key_encrypter_map = {
    for pair in setproduct(var.encrypters, var.set_encrypters_for_keys) :
    "${pair[0]}-${pair[1]}" => {
      encrypter = pair[0]
      key       = pair[1]
    }
  }

  key_ring_encrypter_map = {
    for pair in setproduct(var.encrypters, [var.keyring]) :
    "${pair[0]}-${pair[1]}" => {
      encrypter = pair[0]
      key_ring  = pair[1]
    }
  }

  key_operator_map = {
    for pair in setproduct(var.operators, var.set_crypto_operators_for_keys) :
    "${pair[0]}-${pair[1]}" => {
      encrypter = pair[0]
      key       = pair[1]
    }
  }

  key_ring_operator_map = {
    for pair in setproduct(var.operators, [var.keyring]) :
    "${pair[0]}-${pair[1]}" => {
      encrypter = pair[0]
      key_ring  = pair[1]
    }
  }
}

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

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = each.value["symmetric_key_protection_level"]
  }

  labels = each.value["labels"]
}

#KMS IAM

## roles/cloudkms.cryptoOperator:

# for assigning the role roles/cloudkms.cryptoOperator on a key
resource "google_kms_crypto_key_iam_member" "operators_for_key" {
  for_each      = local.key_decrypter_map
  role          = "roles/cloudkms.cryptoOperator"
  crypto_key_id = "projects/${var.project_id}/locations/${var.location}/keyRings/${var.keyring}/cryptoKeys/${each.value.key}"
  member        = each.value.decrypter

  depends_on = [
    google_kms_crypto_key.symmetric_key_with_rotation_period,
    google_kms_crypto_key.asymmetric_key,
    google_kms_crypto_key.symmetric_key,
    google_kms_key_ring.key_ring
  ]
}
# for assigning the role roles/cloudkms.cryptoOperator on a key ring
resource "google_kms_key_ring_iam_member" "operators_for_key_ring" {
  for_each    = local.key_ring_decrypter_map
  role        = "roles/cloudkms.cryptoOperator"
  key_ring_id = "projects/${var.project_id}/locations/${var.location}/keyRings/${var.keyring}"
  member      = each.value.decrypter

  depends_on = [
    google_kms_key_ring.key_ring
  ]
}


## roles/cloudkms.cryptoKeyDecrypter

# for assigning decrypter role on a key 
resource "google_kms_crypto_key_iam_member" "decrypters_for_key" {
  for_each      = local.key_decrypter_map
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = "projects/${var.project_id}/locations/${var.location}/keyRings/${var.keyring}/cryptoKeys/${each.value.key}"
  member        = each.value.decrypter

  depends_on = [
    google_kms_crypto_key.symmetric_key_with_rotation_period,
    google_kms_crypto_key.asymmetric_key,
    google_kms_crypto_key.symmetric_key,
    google_kms_key_ring.key_ring
  ]
}
#for assigning decrypter role on a key ring
resource "google_kms_key_ring_iam_member" "decrypters_for_key_ring" {
  for_each    = local.key_ring_decrypter_map
  role        = "roles/cloudkms.cryptoKeyDecrypter"
  key_ring_id = "projects/${var.project_id}/locations/${var.location}/keyRings/${var.keyring}"
  member      = each.value.decrypter

  depends_on = [
    google_kms_key_ring.key_ring
  ]
}
## roles/cloudkms.cryptoKeyEncrypter
# for assigning encrypter role on a key
resource "google_kms_crypto_key_iam_member" "encrypters_for_key" {
  for_each      = local.key_encrypter_map
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = "projects/${var.project_id}/locations/${var.location}/keyRings/${var.keyring}/cryptoKeys/${each.value.key}"
  member        = each.value.encrypter

  depends_on = [
    google_kms_crypto_key.symmetric_key_with_rotation_period,
    google_kms_crypto_key.asymmetric_key,
    google_kms_crypto_key.symmetric_key,
    google_kms_key_ring.key_ring
  ]
}
# for assigning encrypter role on a key ring
resource "google_kms_key_ring_iam_member" "encrypters_for_key_ring" {
  for_each    = local.key_ring_encrypter_map
  role        = "roles/cloudkms.cryptoKeyEncrypter"
  key_ring_id = "projects/${var.project_id}/locations/${var.location}/keyRings/${var.keyring}"
  member      = each.value.encrypter

  depends_on = [
    google_kms_key_ring.key_ring
  ]
}


