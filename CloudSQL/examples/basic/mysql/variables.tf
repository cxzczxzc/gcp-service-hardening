variable "db_version" {
  description = "The database version to use"
  type        = string
}

variable "disk_size" {
  description = "The disk size for the master instance."
  type        = number
}

variable "db_name" {
  description = "The name of the SQL Database instance"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network to peer."
  type        = string
}

variable "region" {
  type        = string
  description = "The region of the Cloud SQL resources"
}

variable "db_tier" {
  description = "The tier for the master instance."
  type        = string
}

variable "zone" {
  type        = string
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
}

variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "shared_vpc_project_id" {
  description = "The ID of the Shared VPC project."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the Shared VPC"
  type        = string
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool

}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags)"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    start_time                     = string
    location                       = string
    point_in_time_recovery_enabled = bool
    transaction_log_retention_days = string
    retained_backups               = number
    retention_unit                 = string
  })
}