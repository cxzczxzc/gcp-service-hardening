
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "location" {
  description = "Location for the keyring."
  type        = string
  default     = "global"
}

variable "keyring" {
  description = "Keyring name."
  type        = string
}

# The key purpose for asymmetric keys can be ASYMMETRIC_DECRYPT or ASYMMETRIC_SIGN
# see this link for algorithms supported by each key purpose: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm
# the possible value for protection level can be either SOFTWARE or HSM
variable "asymmetric_keys" {
  description = "Map of attributes involved in creation of asymmetric keys"
  type = map(object({
    asymmetric_key_name             = string
    asymmetric_key_purpose          = string
    asymmetric_key_algorithm        = string
    asymmetric_key_protection_level = string
    labels                          = optional(map(string))
  }))
  default = {}
}

# automatic rotation of keys is only possible when the key purpose is ENCRYPT_DECRYPT
# key purpose ENCRYPT_DECRYPT only works with the algorithm GOOGLE_SYMMETRIC_ENCRYPTION
# the possible value for protection level can be either SOFTWARE or HSM
variable "symmetric_keys_auto_rotate" {
  description = "Map of attributes involved in creation of symmetric keys with automatic rotation enabled"
  type = map(object({
    symmetric_key_name             = string
    symmetric_key_protection_level = string
    symmetric_key_rotation_period  = string
    labels                         = optional(map(string))
  }))
  default = {}
}
# The key purpose for symmetric keys can be either MAC or ENCRYPT_DECRYPT
# see this link for algorithms supported by each key purpose: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm
# the possible value for protection level can be either SOFTWARE or HSM
variable "symmetric_keys" {
  description = "Map of attributes involved in creation of symmetric keys"
  type = map(object({
    symmetric_key_name             = string
    symmetric_key_purpose          = string
    symmetric_key_algorithm        = string
    symmetric_key_protection_level = string
    labels                         = optional(map(string))
  }))
  default = {}
}

# list of identities that you want to assign the decrypter role on the key or key ring
variable "key_decrypters" {
  description = <<EOF
  List of comma-separated principals.
  These principals will get roles/cloudkms.cryptoKeyEncrypter. This role
  contains the permissions required for using the key to encrypt data. 
  The principals must start with the prefix that indicates the type of principal.
  Eg. "serviceAccount:", "user:", "group:" etc.
  
  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles
  EOF
  type        = list(string)
  default     = []
}
# list of key names to which you want to assign the decrypter role
variable "keys_to_set_decrypters_for" {
  type    = list(string)
  default = []
}

# list of identities that you want to assign the encrypter role on the key or key ring
variable "key_encrypters" {
  description = <<EOF
  List of comma-separated principals.
  These principals will get roles/cloudkms.cryptoKeyEncrypter. This role
  contains the permissions required for using the key to encrypt data. 
  The principals must start with the prefix that indicates the type of principal.
  Eg. "serviceAccount:", "user:", "group:" etc.
  
  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles
  EOF
  type        = list(string)
  default     = []
}
# list of key names to which you want to assign the encrypter role
variable "keys_to_set_encrypters_for" {
  description = "Comma separated names of the Cloud KMS keys for which roles/cloudkms.cryptoKeyEncrypter will be granted"
  type        = list(string)
  default     = []
}

variable "crypto_key_operators" {
  description = <<EOF
  List of comma-separated principals.
  These principals will get roles/cloudkms.cryptoOperator. This role
  contains the permissions required for using the key to encrypt, decrypt, sign, and verify data. 
  The principals must start with the prefix that indicates the type of principal.
  Eg. "serviceAccount:", "user:", "group:" etc.

  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles
  EOF
  type        = list(string)
  default     = []
}
variable "keys_to_set_operators_for" {
  description = "Comma separated names of the Cloud KMS keys for which roles/cloudkms.cryptoOperator will be granted"
  type        = list(string)
  default     = []
}