module "kms" {
  source     = "../.."
  project_id = var.project_id
  location   = var.location
  keyring    = var.keyring

  # key creation - specify the type of keys to be created
  asymmetric_keys            = var.asymmetric_keys
  symmetric_keys_auto_rotate = var.symmetric_keys_auto_rotate
  symmetric_keys             = var.symmetric_keys
  # add IAM bindings
  operators                     = var.crypto_key_operators
  set_crypto_operators_for_keys = var.keys_to_set_operators_for
  
  decrypters              = var.key_decrypters
  set_decrypters_for_keys = var.keys_to_set_decrypters_for

  encrypters              = var.key_encrypters
  set_encrypters_for_keys = var.keys_to_set_encrypters_for
}

