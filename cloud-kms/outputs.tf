output "asymmetric_keys" {
  value = {
    for k in google_kms_crypto_key.asymmetric_key :
    k.name => k.id
  }
  description = "Map of generated asymmetric crypto keys."
}

output "symmetric_keys" {
  value = {
    for k in google_kms_crypto_key.symmetric_key :
    k.name => k.id
  }
  description = "Map of generated symmetric crypto keys."
}

output "symmetric_keys_auto_rotate" {
  value = {
    for k in google_kms_crypto_key.symmetric_key_with_rotation_period :
    k.name => k.id
  }
  description = "Map of generated symmetric crypto keys auto rotate."
}