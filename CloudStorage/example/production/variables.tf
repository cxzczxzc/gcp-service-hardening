variable "name" {
  description = "The name of the bucket."
  type        = string
}
variable "location" {
  description = "The GCP region to deploy to."
  type        = string
}

variable "project_id" {
  description = "project_id of GCP project to deploy"
  type        = string
}

variable "environment" {
  type        = string
  description = "Project environment (prod, nonprod, sandbox)."

  validation {
    condition     = contains(["prod", "nonprod", "sandbox"], var.environment)
    error_message = "Environment must be one of the following: prod, nonprod, sandbox."
  }
}

variable "log_bucket" {
  description = "The bucket that will receive log objects."
  type        = string
  default     = null
}