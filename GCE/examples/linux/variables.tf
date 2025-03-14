variable "region" {
  description = "The GCP zone to deploy to - default is us-east4"
  type        = string
  default     = "us-east4"
}

variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "instance_tags" {
  type    = list(string)
  default = ["ssh-in", "ad-client", "cyberark"]
}

variable "devx_url" {
  type    = string
}

variable "org" {
  description = "GCP Org to create resources in.  Defaults to 'mainorg'"
  type        = string
  default     = "mainorg"
}

variable "environment" {
  type        = string
  description = "Application environment stage"
  default     = "nonprod"
  validation {
    condition     = contains(["nonprod", "prod"], var.environment)
    error_message = "Valid values for var: environment are (nonprod,prod)."
  }
}

variable "devx_api_token" {
  type    = string
  default = "password"
}

variable "drn" {
  type    = string
  default = "3316"
}

variable "cmdb_url" {
  type    = string
}

variable "additional_disks" {
  description = "List of maps of additional disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#disk_name"
  type = list(object({
    disk_name    = string
    device_name  = string
    auto_delete  = bool
    boot         = bool
    disk_size_gb = number
    disk_type    = string
    disk_labels  = map(string)
  }))
  default = []
}

variable "stateful_disks" {
  description = "Disks created on the instances that will be preserved on instance delete. https://cloud.google.com/compute/docs/instance-groups/configuring-stateful-disks-in-migs"
  type = list(object({
    device_name = string
    delete_rule = string
  }))
  default = []
}

variable "hostname" {
  description = "Hostname prefix for instances."
  default     = "default"
}

variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  default     = ""
}

variable "subnetwork_project_id" {
  description = "The project that subnetwork belongs to"
  default     = ""
}

variable "source_image_type" {
  description = "Source image type. Defaults."
  default     = "rhel8"
}

variable "os_patch_week_of_the_month" {
  type        = number
  description = "Week(1 to 4) of the Month to apply patches."
}

variable "os_patch_day_of_the_week" {
  type        = string
  description = "Day(MONDAY to SUNDAY) of the week to apply patches."
}

variable "os_patch_hours_of_the_day" {
  type        = number
  description = "Hour(0 to 24) of the day to apply patches."
}

variable "os_patch_minutes_of_the_day" {
  type        = number
  description = "Minutes(0 to 59) of the day to apply patches."
}
