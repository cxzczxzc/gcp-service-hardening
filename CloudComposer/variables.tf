variable "project_id" {
  description = "Project ID where Cloud Composer Environment is created."
  type        = string
}

variable "region" {
  description = "Region where the Cloud Composer Environment is created."
  type        = string
  default     = "us-central1"
}

variable "composer_env_name" {
  description = "Name of Cloud Composer Environment"
  type        = string
}

variable "service_account_name" {
  description = "Service Account to be used for running Cloud Composer Environment."
  type        = string
}

variable "network" {
  description = "Network where Cloud Composer is created."
  type        = string
}

variable "network_project_id" {
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  type        = string
}

variable "subnetwork" {
  description = "Subetwork where Cloud Composer is created."
  type        = string
}

variable "environment_size" {
  description = "The environment size controls the performance parameters of the managed Cloud Composer infrastructure that includes the Airflow database. Values for environment size are ENVIRONMENT_SIZE_SMALL, ENVIRONMENT_SIZE_MEDIUM, and ENVIRONMENT_SIZE_LARGE"
  type        = string
}

variable "pod_ip_allocation_range_name" {
  description = "The name of the cluster's secondary range used to allocate IP addresses to pods."
  type        = string
}

variable "service_ip_allocation_range_name" {
  type        = string
  description = "The name of the services' secondary range used to allocate IP addresses to the cluster."
}

variable "image_version" {
  type        = string
  description = "The version of the aiflow running in the cloud composer environment."
  default     = "composer-2.0.2-airflow-2.1.4"
}

variable "enable_ip_masq_agent" {
  description = "Deploys 'ip-masq-agent' daemon set in the GKE cluster and defines nonMasqueradeCIDRs equals to pod IP range so IP masquerading is used for all destination addresses, except between pods traffic."
  type        = bool
  default     = false
}

variable "additional_network_tags" {
  type        = list(any)
  description = "The network tags in the cloud composer environment."
  default     = []
}

variable "scheduler" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
    count      = number
  })
  default = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 10
    count      = 2
  }
  description = "Configuration for resources used by Airflow schedulers."
}

variable "web_server" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
  })
  default = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 10
  }
  description = "Configuration for resources used by Airflow web server."
}

variable "worker" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
    min_count  = number
    max_count  = number
  })
  default = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 10
    min_count  = 2
    max_count  = 6
  }
  description = "Configuration for resources used by Airflow workers."
}
variable "cloud_composer_network_ipv4_cidr_block" {
  description = "The CIDR block from which IP range in tenant project will be reserved."
  type        = string
  default     = null
}
variable "cloud_sql_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for Cloud SQL."
  type        = string
  default     = null
}

variable "pypi_packages" {
  type        = map(string)
  description = " Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. \"numpy\")."
  default     = {}
}

variable "airflow_config_overrides" {
  type        = map(string)
  description = "Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example \"core-dags_are_paused_at_creation\"."
  default     = {}
}

variable "env_variables" {
  type        = map(string)
  description = "Variables of the airflow environment."
  default     = {}
}

variable "environment" {
  type        = string
  description = "Application environment stage"
  default     = "non_prod"
  validation {
    condition     = contains(["non_prod", "prod"], var.environment)
    error_message = "Valid values for var: environment are (non_prod, prod)."
  }
}

variable "cloud_composer_connection_subnetwork" {
  description = "Subnet for PSC endpoint. Refer to the conditional logic in main.tf, this defaults to node subnet. See: https://cloud.google.com/composer/docs/composer-2/environment-architecture#private-ip-psc"
  type        = string
  default     = null
}
