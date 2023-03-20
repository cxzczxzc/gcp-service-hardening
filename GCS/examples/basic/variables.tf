variable "region" {
  description = "The GCP region to deploy to."
  type        = string
  default     = "us-east4"
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

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects when set to true. If this value is set to false and you try to delete a bucket that contains objects, Terraform will fail."
  default     = false
}