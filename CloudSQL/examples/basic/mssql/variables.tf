variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "shared_vpc_id" {
  description = "The ID of the Shared VPC."
  type        = string
}

variable "allocated_ip_range" {
  type        = string
  description = "The name of the allocated ip range for the private ip cloud sql instance."
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

variable "region" {
  type        = string
  description = "The region of the Cloud SQL resources"
  default     = "us-central1"
}

variable "db_tier" {
  description = "The tier for the master instance."
  type        = string
  default     = "db-f1-micro"
}

variable "zone" {
  type        = string
  description = "The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = "us-central1-a"
}

variable "availability_type" {
  description = "The availability type for the master instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = "ZONAL"
}

variable "user_labels" {
  description = "The key/value labels for the master instances."
  type        = map(string)
  default     = {}
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/sqlserver/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "active_directory_config" {
  description = "Active domain that the SQL instance will join."
  type        = map(string)
  default     = {}
}

// required
variable "db_version" {
  description = "The database version to use: SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, or SQLSERVER_2017_WEB"
  type        = string
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
}