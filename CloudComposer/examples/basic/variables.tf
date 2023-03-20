variable "project_id" {
  description = "Project ID where Cloud Composer Environment is created."
  type        = string
}
variable "region" {
  description = "Region where the Cloud Composer Environment is created."
  type        = string
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
variable "network_project_id" {
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  type        = string
}
variable "cloud_composer_network_ipv4_cidr_block" {
  description = "The CIDR block from which IP range in tenant project will be reserved."
  type        = string
}
variable "cloud_sql_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for Cloud SQL."
  type        = string
}
variable "pypi_packages" {
  type        = map(string)
  description = " Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. \"numpy\")."
}
variable "additional_network_tags" {
  type        = list(any)
  description = "The network tags in the cloud composer environment."
  default     = []
}

variable "airflow_config_overrides" {
  type        = map(string)
  description = "Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example \"core-dags_are_paused_at_creation\"."
}

variable "env_variables" {
  type        = map(string)
  description = "Variables of the airflow environment."
}