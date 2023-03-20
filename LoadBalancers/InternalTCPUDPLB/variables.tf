variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable "region" {
  description = "Region for cloud resources."
  default     = "us-east4"
}

variable "global_access" {
  description = "Allow all regions on the same VPC network access."
  type        = bool
  default     = false
}

variable "network" {
  description = "Name of the network to create resources in."
  type        = string
}

variable "subnetwork" {
  description = "Name of the subnetwork to create resources in."
  type        = string
}

variable "network_project" {
  description = "Name of the project for the network. Useful for shared VPC. Default is var.project."
  default     = ""
}

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources."
}

variable "load_balancing_scheme" {
  description = "value"
  type        = string
  default     = "INTERNAL"
}

variable "backends" {
  description = "List of backends, should be a map of key-value pairs for each backend, must have the 'group' key."
  type        = list(any)
}

variable "session_affinity" {
  description = "The session affinity for the backends example: NONE, CLIENT_IP. Default is `NONE`."
  default     = "NONE"
}

variable "ports" {
  description = "List of ports range to forward to backend services. Max is 5."
  type        = list(string)
}

variable "all_ports" {
  description = "Boolean for all_ports setting on forwarding rule."
  type        = bool
  default     = null
}

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    name                = optional(string)
    type                = string
    check_interval_sec  = optional(number)
    healthy_threshold   = optional(number)
    timeout_sec         = optional(number)
    unhealthy_threshold = optional(number)
    response            = optional(string)
    proxy_header        = optional(string)
    port                = optional(number)
    port_name           = optional(string)
    request             = optional(string)
    request_path        = optional(string)
    host                = optional(string)
    enable_log          = optional(bool)
  })
}

variable "ip_address" {
  description = "IP address of the internal load balancer, if empty one will be assigned. Default is empty."
  default     = null
}

variable "ip_protocol" {
  description = "The IP protocol for the backend and frontend forwarding rule. TCP or UDP."
  default     = "TCP"
}

variable "service_label" {
  description = "Service label is used to create internal DNS name"
  default     = null
  type        = string
}

variable "connection_draining_timeout_sec" {
  description = "Time for which instance will be drained"
  default     = null
  type        = number
}

variable "labels" {
  description = "The labels to attach to resources created by this module."
  default     = {}
  type        = map(string)
}