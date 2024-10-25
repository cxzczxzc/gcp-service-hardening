variable "project_id" {
  description = "Project id where the keyring will be created."
  type        = string
}

# region where the key will be located
variable "location" {
  description = "Location for the keyring."
  type        = string
}

# name of the keyring 
# it is recommended to group similar keys into one keyring for simplified management
variable "keyring" {
  description = "Keyring name."
  type        = string
}

# The key purpose for asymmetric keys can be ASYMMETRIC_DECRYPT or ASYMMETRIC_SIGN
# see this link for algorithms supported by each key purpose: https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm
# the possible value for protection level can be either SOFTWARE or HSM
variable "asymmetric_keys" {
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
  type = map(object({
    symmetric_key_name             = string
    symmetric_key_purpose          = string
    symmetric_key_algorithm        = string
    symmetric_key_protection_level = string
    labels                         = optional(map(string))
  }))
  default = {}
}
variable "set_encrypters_for_keys" {
  description = "Name of keys for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "encrypters" {
  description = <<EOF
  List of comma-separated principals for each key declared in set_encrypters_for. 
  These principals will get roles/cloudkms.cryptoKeyEncrypter. This role
  contains the permissions required for using the key to encrypt data. 
  The principals must start with the prefix that indicates the type of principal.
  Eg. "serviceAccount:", "user:", "group:" etc.
  
  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles
  EOF
  type        = list(string)
  default     = []
}

variable "set_decrypters_for_keys" {
  description = "Name of keys for which decrypters will be set."
  type        = list(string)
  default     = []
}

variable "decrypters" {
  description = <<EOF
  List of comma-separated principals for each key declared in set_decrypters_for. 
  These principals will get roles/cloudkms.cryptoKeyDecrypter. This role
  contains the permissions required for using the key to decrypt data. 
  The principals must start with the prefix that indicates the type of principal.
  Eg. "serviceAccount:", "user:", "group:" etc.

  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles

  EOF
  type        = list(string)
  default     = []
}

variable "set_crypto_operators_for_keys" {
  description = "Name of keys for which crypto operators will be set."
  type        = list(string)
  default     = []
}

variable "operators" {
  description = <<EOF
  List of comma-separated principals for each key declared in set_operators_for. 
  These principals will get roles/cloudkms.cryptoOperator. This role
  contains the permissions required for using the key to encrypt, decrypt, sign, and verify data. 
  The principals must start with the prefix that indicates the type of principal.
  Eg. "serviceAccount:", "user:", "group:" etc.

  For more information about roles and permissions check this: https://cloud.google.com/kms/docs/reference/permissions-and-roles
  EOF
  type        = list(string)
  default     = []
}






