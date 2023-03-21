
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "dnb-playground"
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
# list of identities that you want to assign the owner role on the key or key ring
variable "key_owners" {
  type    = list(string)
  default = []
}
# list of key names to which you want to assign the owner role
variable "keys_to_set_owners_for" {
  type    = list(string)
  default = []
}
# list of key ring names to which you want to assign the owner role
variable "key_rings_to_set_owners_for" {
  type    = list(string)
  default = []
}
# list of identities that you want to assign the decrypter role on the key or key ring
variable "key_decrypters" {
  type    = list(string)
  default = []
}
# list of key names to which you want to assign the decrypter role
variable "keys_to_set_decrypters_for" {
  type    = list(string)
  default = []
}
# list of key ring names to which you want to assign the decrypter role
variable "key_rings_to_set_decrypters_for" {
  type    = list(string)
  default = []
}

# list of identities that you want to assign the encrypter role on the key or key ring
variable "key_encrypters" {
  type    = list(string)
  default = []
}
# list of key names to which you want to assign the encrypter role
variable "keys_to_set_encrypters_for" {
  type    = list(string)
  default = []
}
# list of key ring names to which you want to assign the encrypter role
variable "key_rings_to_set_encrypters_for" {
  type    = list(string)
  default = []
}