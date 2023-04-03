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

variable "storage_class" {
  description = "The Storage Class of the new bucket."
  type        = string
  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Validation: storage class must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects when set to true. If this value is set to false and you try to delete a bucket that contains objects, Terraform will fail."
}