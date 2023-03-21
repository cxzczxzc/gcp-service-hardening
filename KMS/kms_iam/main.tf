locals {
  key_owner_map = {
    for pair in setproduct(var.owners, var.set_owners_for_keys) :
    "${pair[0]}-${pair[1]}" => {
      owner = pair[0]
      key   = pair[1]
    }
  }
  key_ring_owner_map = {
    for pair in setproduct(var.owners, var.set_owners_for_key_rings) :
    "${pair[0]}-${pair[1]}" => {
      owner    = pair[0]
      key_ring = pair[1]
    }
  }

  key_decrypter_map = {
    for pair in setproduct(var.decrypters, var.set_decrypters_for_keys) :
    "${pair[0]}-${pair[1]}" => {
      decrypter = pair[0]
      key       = pair[1]
    }
  }

  key_ring_decrypter_map = {
    for pair in setproduct(var.decrypters, var.set_decrypters_for_key_rings) :
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
    for pair in setproduct(var.encrypters, var.set_encrypters_for_key_rings) :
    "${pair[0]}-${pair[1]}" => {
      encrypter = pair[0]
      key_ring  = pair[1]
    }
  }


}

# for assigning owner role on a key 
resource "google_kms_crypto_key_iam_member" "owners_for_key" {
  for_each      = local.key_owner_map
  role          = "roles/owner"
  crypto_key_id = "${var.project_id}/${var.location}/${var.keyring}/${each.value.key}"
  member        = each.value.owner
}
# for assigning owner role on a key ring
resource "google_kms_key_ring_iam_member" "owners_for_key_ring" {
  for_each    = local.key_ring_owner_map
  role        = "roles/owner"
  key_ring_id = "${var.project_id}/${var.location}/${each.value.key_ring}"
  member      = each.value.owner
}
# for assigning decrypter role on a key 
resource "google_kms_crypto_key_iam_member" "decrypters" {
  for_each      = local.key_decrypter_map
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  crypto_key_id = "${var.project_id}/${var.location}/${var.keyring}/${each.value.key}"
  member        = each.value.decrypter
}
# for assigning decrypter role on a key ring
resource "google_kms_key_ring_iam_member" "decrypters_for_key_ring" {
  for_each    = local.key_ring_decrypter_map
  role        = "roles/cloudkms.cryptoKeyDecrypter"
  key_ring_id = "${var.project_id}/${var.location}/${each.value.key_ring}"
  member      = each.value.decrypter
}
# for assigning encrypter role on a key
resource "google_kms_crypto_key_iam_member" "encrypters" {
  for_each      = local.key_encrypter_map
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  crypto_key_id = "${var.project_id}/${var.location}/${var.keyring}/${each.value.key}"
  member        = each.value.encrypter
}
# for assigning encrypter role on a key ring
resource "google_kms_key_ring_iam_member" "encrypters_for_key_ring" {
  for_each    = local.key_ring_encrypter_map
  role        = "roles/cloudkms.cryptoKeyEncrypter"
  key_ring_id = "${var.project_id}/${var.location}/${each.value.key_ring}"
  member      = each.value.encrypter
}
