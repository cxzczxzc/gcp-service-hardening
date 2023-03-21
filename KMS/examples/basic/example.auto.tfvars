keyring  = "map-generated-keys"
location = "us-east1"

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
# set owners for keys
key_owners                  = ["user:saadx@google.com", "serviceAccount:dnb-iam@dnb-playground.iam.gserviceaccount.com"]
keys_to_set_owners_for      = ["symmetric-encrypt-decrypt-key", "mac-signing-verification-key"]
key_rings_to_set_owners_for = ["map-generated-keys"]

# set decrypters for keys
key_decrypters                  = ["user:saadx@google.com", "serviceAccount:dnb-iam@dnb-playground.iam.gserviceaccount.com"]
keys_to_set_decrypters_for      = ["symmetric-encrypt-decrypt-key-autorotate-1"]
key_rings_to_set_decrypters_for = ["map-generated-keys"]

# set encrypters for keys
key_encrypters                  = ["user:saadx@google.com", "serviceAccount:dnb-iam@dnb-playground.iam.gserviceaccount.com"]
keys_to_set_encrypters_for      = ["asymmetric-sign-key"]
key_rings_to_set_encrypters_for = ["map-generated-keys"]