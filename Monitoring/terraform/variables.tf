variable "org_id" {
  description = "Numeric ID of Organization"
  type        = string
}

variable "project" {
  description = "Project to run admin commands against"
  type        = string
}

variable "region" {
  type        = string
  description = "Default region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Default zone"
  default     = "us-central1-a"
}

variable "org_admin_email" {
  type        = string
  description = "email address for org administrator"
}
