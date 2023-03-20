variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "secret_name" {
  type        = string
  description = "Name of the Secret manager"
}

variable "secret_data" {
  type        = string
  description = "The secret data in the secret version"
}

variable "replication" {
  type        = map(any)
  description = "An optional map of replication configurations for the secret"
}

variable "region" {
  description = "The region of the secret manager replication"
  type        = string
}
