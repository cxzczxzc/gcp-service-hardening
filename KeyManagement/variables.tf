variable "project_id" {
  description = "Project id where the keyring will be created."
  type        = string
}

# cf https://cloud.google.com/kms/docs/locations
variable "location" {
  description = "Location for the keyring."
  type        = string
  default     = "global"
}

variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "keys" {
  description = "Key names."
  type        = list(string)
  default     = []
}

variable "prevent_destroy" {
  description = "Set the prevent_destroy lifecycle attribute on keys."
  default     = true
}

variable "purpose" {
  type        = string
  description = "The immutable purpose of the CryptoKey. Possible values are ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, ASYMMETRIC_DECRYPT and MAC."
  default     = "ENCRYPT_DECRYPT"
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "ASYMMETRIC_SIGN", "ASYMMETRIC_DECRYPT", "MAC"], var.purpose)
    error_message = "Purpose must be one of the following: ENCRYPT_DECRYPT, ASYMMETRIC_SIGN, ASYMMETRIC_DECRYPT, MAC."
  }
}

variable "set_owners_for" {
  description = "Name of keys for which owners will be set."
  type        = list(string)
  default     = []
}

variable "owners" {
  description = "List of comma-separated owners for each key declared in set_owners_for."
  type        = list(string)
  default     = []
}

variable "set_encrypters_for" {
  description = "Name of keys for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "encrypters" {
  description = "List of comma-separated owners for each key declared in set_encrypters_for."
  type        = list(string)
  default     = []
}

variable "set_decrypters_for" {
  description = "Name of keys for which decrypters will be set."
  type        = list(string)
  default     = []
}

variable "decrypters" {
  description = "List of comma-separated owners for each key declared in set_decrypters_for."
  type        = list(string)
  default     = []
}

# Default Key Rotation is Set to 90 Days. 86400s == 1 Day
variable "key_rotation_period" {
  description = "Key Rotation period for symmetric keys. Default is 90 days."
  type        = string
  default     = "7776000s"
}

variable "key_algorithm" {
  type        = string
  description = "The algorithm to use when creating a version based on this template. See the https://cloud.google.com/kms/docs/reference/rest/v1/CryptoKeyVersionAlgorithm for possible inputs."
  default     = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "key_protection_level" {
  type        = string
  description = "The protection level to use when creating a version based on this template."
  default     = "SOFTWARE"
  validation {
    condition     = contains(["SOFTWARE", "HSM", "EXTERNAL", "EXTERNAL_VPC"], var.key_protection_level)
    error_message = "Protection Level must be one of the following: SOFTWARE, HSM, EXTERNAL, EXTERNAL_VPC."
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}