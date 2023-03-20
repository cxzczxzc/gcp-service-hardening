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

variable "project_id" {
  description = "Project ID where most resorces are being created"
  type        = string
}

variable "org_id" {
  description = "Numeric ID of Organization"
  type        = string
}

variable "labels" {
  description = "Map of labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Cribl external service account"
  type        = string
}

variable "svc_pub_key" {
  description = "RSA X509 public key in pem file for exteranl authentication"
  type        = string
}

variable "admin_pipeline" {
  description = "Admin logs pipeline id used to construct resource names"
  type        = string
}

variable "admin_log_filter" {
  description = "Org level filter for admin events"
  type        = string
}

variable "admin_log_excl_filter" {
  description = "Org level exclusion filter for admin events"
  type        = string
}

variable "network_pipeline" {
  description = "Network logs (firewall and VPC FLow) pipeline id used to construct resource names"
  type        = string
}

variable "network_log_filter" {
  description = "Org level filter for network events"
  type        = string
}

variable "prod_pipeline" {
  description = "Production projects logs pipeline id used to construct resource names"
  type        = string
}

variable "nonprod_pipeline" {
  description = "Non-Prod projects logs pipeline id used to construct resource names"
  type        = string
}

variable "sink_project_ids" {
  type        = list(string)
  description = "list of project IDs to create sink"
  default     = []
}

variable "devx-tfc-api-token" {
  type        = string
  description = "The secret token for access to DevX rest API"
  default     = "password"
}

