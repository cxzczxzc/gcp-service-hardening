variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
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
