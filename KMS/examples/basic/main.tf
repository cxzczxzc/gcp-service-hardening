module "kms" {
  source                     = "../.."
  project_id                 = var.project_id
  location                   = var.location
  keyring                    = var.keyring
  asymmetric_keys            = var.asymmetric_keys
  symmetric_keys_auto_rotate = var.symmetric_keys_auto_rotate
  symmetric_keys             = var.symmetric_keys
}

module "kms_iam" {
  source     = "../../kms_iam/"
  project_id = var.project_id
  keyring    = var.keyring
  location   = var.location

  owners                   = var.key_owners
  set_owners_for_keys      = var.keys_to_set_owners_for
  set_owners_for_key_rings = var.key_rings_to_set_owners_for

  decrypters                   = var.key_decrypters
  set_decrypters_for_keys      = var.keys_to_set_decrypters_for
  set_decrypters_for_key_rings = var.key_rings_to_set_decrypters_for

  encrypters                   = var.key_encrypters
  set_encrypters_for_keys      = var.keys_to_set_encrypters_for
  set_encrypters_for_key_rings = var.key_rings_to_set_encrypters_for

  depends_on = [
    module.kms
  ]
}