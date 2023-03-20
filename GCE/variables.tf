# Attribution, large copy-paste from: https://raw.githubusercontent.com/terraform-google-modules/terraform-google-vm/master/examples/mig/full/variables.tf

#########
# Common
#########

variable "hostname" {
  description = "Hostname prefix for instances."
  default     = "default"
}

variable "region" {
  description = "The GCP region where instances will be deployed."
  type        = string
  default     = "us-east4"
}

variable "environment" {
  description = "The GCP environment where instances will be deployed."
  type        = string
  default     = "non_prod"
  validation {
    condition     = var.environment == "sandbox" || var.environment == "non_prod" || var.environment == "prod"
    error_message = "Accepted values are `sandbox`, `non_prod` and `prod`."
  }
}

variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  default     = ""
}

variable "subnetwork_project_id" {
  description = "The project that subnetwork belongs to"
  default     = ""
}

variable "named_ports" {
  description = "Named name and named port"
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

####################
# Instance Template
####################
variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "f1-micro"
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = ["ssh-in"]
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

/* disk */
variable "source_image" {
  description = "Source disk image. If not specified, defaults to the data from HCP Packer."
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If not specified, defaults to the data from HCP Packer."
  default     = ""
}

variable "source_image_project" {
  description = "Project where the source image comes from. If not specified, defaults to the data from HCP Packer."
  default     = ""
}

variable "source_image_type" {
  description = "Source image type. Defaults to rhel8."
  default     = "rhel8"
  validation {
    condition     = var.source_image_type == "rhel8" || var.source_image_type == "win2019"
    error_message = "Accepted values are `rhel8` OR `win2019`."
  }
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  default     = "30"
}

variable "disk_type" {
  description = "Disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "disk_labels" {
  description = "Labels to be assigned to boot disk, provided as a map"
  default     = {}
}

variable "auto_delete" {
  description = "Whether or not the disk should be auto-deleted"
  default     = "false"
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


/* metadata */
variable "startup_script" {
  description = "User startup script to run when instances spin up. For windows Powershell scrip, we have to use metadata variable to pass in the script file."
  default     = ""
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map. It could be used to add windows Startup script by adding Key:windows-startup-script-ps1 and Value:YOUR_POWERSHELL_SCRIPT."
  default     = {}
}

/* service account */
variable "service_account" {
  default = null
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

##########################
# Mananged Instance Group
##########################

variable "target_size" {
  description = "The target number of running instances for this managed or unmanaged instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
  default     = 2
}

variable "target_pools" {
  description = "The target load balancing pools to assign this group to."
  type        = list(string)
  default     = []
}

variable "distribution_policy_zones" {
  description = "The distribution policy, i.e. which zone(s) should instances be create in. Default is all zones in given region."
  type        = list(string)
  default     = []
}

variable "update_policy" {
  description = "The rolling update policy. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager"
  type = list(object({
    max_surge_fixed              = number
    instance_redistribution_type = string
    max_surge_percent            = number
    max_unavailable_fixed        = number
    max_unavailable_percent      = number
    min_ready_sec                = number
    replacement_method           = string
    minimal_action               = string
    type                         = string
  }))
  default = [{
    type                         = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 3
    max_surge_percent            = null
    max_unavailable_fixed        = 0
    max_unavailable_percent      = null
    min_ready_sec                = 50
    replacement_method           = "SUBSTITUTE"
    instance_redistribution_type = "PROACTIVE"
  }]
}


/* health checks */

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    type                = string
    initial_delay_sec   = number
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    request             = string
    request_path        = string
    host                = string
  })
  default = {
    type                = "http"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = ""
  }
}

/* statefull policy on Disks */

variable "stateful_disks" {
  description = "Disks created on the instances that will be preserved on instance delete. https://cloud.google.com/compute/docs/instance-groups/configuring-stateful-disks-in-migs"
  type = list(object({
    device_name = string
    delete_rule = string
  }))
  default = []
}

/* autoscaler */

variable "max_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  default     = 10
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0."
  default     = 2
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  default     = 60
}

variable "autoscaling_cpu" {
  description = "Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#cpu_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_metric" {
  description = "Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#metric"
  type = list(object({
    name   = string
    target = number
    type   = string
  }))
  default = []
}

variable "autoscaling_lb" {
  description = "Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#load_balancing_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_scale_in_control" {
  description = "Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler.html#scale_in_control"
  type = object({
    fixed_replicas   = number
    percent_replicas = number
    time_window_sec  = number
  })
  default = {
    fixed_replicas   = 0
    percent_replicas = 30
    time_window_sec  = 600
  }
}

variable "autoscaling_enabled" {
  description = "Creates an autoscaler for the managed instance group"
  type        = bool
  default     = false
}

##########################
# HCP Packer
##########################
variable "hcp_client_id" {
  description = "Client ID to interact with HCP products"
  default     = ""
}

variable "hcp_client_secret" {
  description = "Client Secret to interact with HCP products"
  default     = ""
  sensitive   = true
}

##########################
# os_patch_deployment
##########################
variable "enable_os_patch_deployment" {
  type        = bool
  description = "Deploys a patch schedule."
  default     = true
}

variable "os_patch_deployment_id" {
  type        = string
  description = "Patch job name."
  default     = ""
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
