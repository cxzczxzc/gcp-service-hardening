variable "project_id" {
  description = "Project id where the keyring will be created."
  type        = string
}

# name of the keyring 
variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "location" {
  description = "Location for the keyring."
  type        = string
}

variable "set_owners_for_keys" {
  description = "Name of keys for which owner will be set."
  type        = list(string)
  default     = []
}

variable "set_owners_for_key_rings" {
  description = "Name of key rings for which owner will be set."
  type        = list(string)
  default     = []
}


variable "owners" {
  description = "List of comma-separated owners for each key declared in set_encrypters_for."
  type        = list(string)
  default     = []
}

variable "set_encrypters_for_keys" {
  description = "Name of keys for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "set_encrypters_for_key_rings" {
  description = "Name of key rings for which encrypters will be set."
  type        = list(string)
  default     = []
}

variable "encrypters" {
  description = "List of comma-separated owners for each key declared in set_encrypters_for."
  type        = list(string)
  default     = []
}

variable "set_decrypters_for_keys" {
  description = "Name of keys for which decrypters will be set."
  type        = list(string)
  default     = []
}

variable "set_decrypters_for_key_rings" {
  description = "Name of key rings for which decrypters will be set."
  type        = list(string)
  default     = []
}


variable "decrypters" {
  description = "List of comma-separated owners for each key declared in set_decrypters_for."
  type        = list(string)
  default     = []
}
