variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "shared_vpc_project_id" {
  description = "The ID of the Shared VPC project."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the Shared VPC."
  type        = string
}

variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

variable "db_name" {
  description = "The name of the SQL Database instance"
  type        = string
}

variable "random_instance_name" {
  type        = bool
  default     = true
  description = "Sets random suffix at the end of the Cloud SQL resource name"
}

variable "network_name" {
  description = "Name of the VPC network to peer."
  type        = string
}

variable "region" {
  type        = string
  description = "The region of the Cloud SQL resources"
  default     = "us-central1"
}

variable "db_tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-custom-4-15360"
}

variable "zone" {
  type        = string
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = "us-central1-a"
}

variable "user_labels" {
  description = "The key/value labels for the master instances."
  type        = map(string)
  default     = {}
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "log_connections"
      value = "on"
    },
    {
      name  = "log_disconnections"
      value = "on"
    },
    {
      name  = "log_statement"
      value = "ddl"
    }
  ]
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = bool
    start_time                     = string
    location                       = string
    point_in_time_recovery_enabled = bool
    transaction_log_retention_days = string
    retained_backups               = number
    retention_unit                 = string
  })
  default = {
    enabled                        = true
    start_time                     = null
    location                       = null
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = "7"
    retained_backups               = 7
    retention_unit                 = "COUNT"
  }
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

// required
variable "db_version" {
  description = "The database version to use"
  type        = string
  default     = "POSTGRES_14"
}

variable "disk_size" {
  description = "The disk size for the master instance."
  type        = number
  default     = 10
}

variable "create_timeout" {
  description = "The optional timout that is applied to limit long database creates."
  type        = string
  default     = "20m"
}

variable "update_timeout" {
  description = "The optional timout that is applied to limit long database updates."
  type        = string
  default     = "20m"
}

variable "delete_timeout" {
  description = "The optional timout that is applied to limit long database deletes."
  type        = string
  default     = "20m"
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "require_ssl" {
  description = "For public IP network, SSL encryption is required"
  type        = bool
  default     = true
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 7
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 4
}


variable "availability_type" {
  description = "The availability type of the Cloud SQL instance. Can be either single zone `ZONAL` or high availability `REGIONAL`."
  type        = string
  default     = "ZONAL"
}