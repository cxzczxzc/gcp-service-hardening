variable "ssl_policy_name" {
  type        = string
  description = "Name of SSL policy"
}

variable "ssl_profile" {
  type        = string
  description = "Profile for SSL policy. Possible values are COMPATIBLE, MODERN, RESTRICTED, and CUSTOM. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy#profile"
}

variable "ssl_min_tls_version" {
  type        = string
  description = "The minimum version of SSL protocol. Possible values are TLS_1_0, TLS_1_1, and TLS_1_2"
  default     = "TLS_1_2"
}

variable "region" {
  type        = string
  description = "SSL policy region"
}

variable "project_id" {
  type        = string
  description = "The ID of the project in which the resource belongs"
}

variable "ssl_policy_global" {
  type        = bool
  description = "SSL policy type, true for global"
}