# If a key-ring is created once, it cannot be deleted
# This is by design in GCP. If you're not using any keys, you will not be charged
# For more details see: https://cloud.google.com/kms/docs/faq#cannot_delete
# Please use a unique key ring name
keyring  = "tf-generated-keyring"
location = "us-east4"

#variable for defining the asymmetric keys that you want to create
asymmetric_keys = {
  "asymmetric-sign-key" = {
    asymmetric_key_algorithm        = "RSA_SIGN_RAW_PKCS1_4096"
    asymmetric_key_name             = "asymmetric-sign-key"
    asymmetric_key_protection_level = "HSM"
    asymmetric_key_purpose          = "ASYMMETRIC_SIGN"
    labels                          = {}
  },
  "asymmetric-decrypt-key" = {
    asymmetric_key_algorithm        = "RSA_DECRYPT_OAEP_4096_SHA512"
    asymmetric_key_name             = "asymmetric-decrypt-key"
    asymmetric_key_protection_level = "SOFTWARE"
    asymmetric_key_purpose          = "ASYMMETRIC_DECRYPT"
    labels                          = {}
  }
}

#variable for defining the symmetric keys with automatic rotation that you want to create
symmetric_keys_auto_rotate = {
  "symmetric-encrypt-decrypt-key-autorotate-1" = {
    labels                         = {}
    symmetric_key_name             = "symmetric-encrypt-decrypt-key-autorotate-1"
    symmetric_key_protection_level = "HSM"
    symmetric_key_rotation_period  = "100000s"
  },
  "symmetric-encrypt-decrypt-key-autorotate-2" = {
    labels                         = {}
    symmetric_key_name             = "symmetric-encrypt-decrypt-key-autorotate-2"
    symmetric_key_protection_level = "SOFTWARE"
    symmetric_key_rotation_period  = "100000s"
  }
}

#variable for defining the asymmetric keys that you want to create (without automatic rotation)
symmetric_keys = {
  "mac-signing-verification-key" = {
    labels                         = {}
    symmetric_key_algorithm        = "HMAC_SHA256"
    symmetric_key_name             = "mac-signing-verification-key"
    symmetric_key_protection_level = "SOFTWARE"
    symmetric_key_purpose          = "MAC"
  },
  "symmetric-encrypt-decrypt-key" = {
    labels                         = {}
    symmetric_key_algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    symmetric_key_name             = "symmetric-encrypt-decrypt-key"
    symmetric_key_protection_level = "HSM"
    symmetric_key_purpose          = "ENCRYPT_DECRYPT"
  },
}

# set operators for keys
crypto_key_operators      = ["serviceAccount:kms-operators@project_id.iam.gserviceaccount.com"]
keys_to_set_operators_for = ["symmetric-encrypt-decrypt-key-autorotate-1", "symmetric-encrypt-decrypt-key-autorotate-2"]

# set decrypters for keys
key_decrypters             = ["serviceAccount:kms-decrypters@project_id.iam.gserviceaccount.com"]
keys_to_set_decrypters_for = ["symmetric-encrypt-decrypt-key-autorotate-1"]

# set encrypters for keys
key_encrypters             = ["serviceAccount:encrypters@project_id.iam.gserviceaccount.com"]
keys_to_set_encrypters_for = ["asymmetric-sign-key"]
