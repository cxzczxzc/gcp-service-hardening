variable "project_id" {
  description = "The project to create test resources within."
  type        = string
}

variable "region" {
  description = "Region for cloud resources."
  type        = string
  default     = "us-east4"
}

variable "network" {
  description = "Network for ILB deployment."
  type        = string
}

variable "network_project" {
  description = "Name of the project for the network. Useful for shared VPC. Default is var.project."
  default     = ""
}


variable "subnetwork" {
  description = "Subnet for ILB deployment."
  type        = string
}