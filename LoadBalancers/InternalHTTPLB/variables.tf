variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = string
}

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources."
  type        = string
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

variable "ip_protocol" {
  description = "The IP protocol for the backend and frontend forwarding rule. HTTP or HTTPS"
  type        = string
  default     = "HTTP"
}

variable "region" {
  description = "ILB region."
  type        = string
  default     = "us-east4"
}

variable "http_forward" {
  description = "Set to `true` to enable HTTP port 80 forward. Also set 'ssl' and 'https_redirect' appropriately."
  type        = bool
  default     = false
}

variable "https_redirect" {
  description = "Set to `false` to disable https redirect on the ILB."
  type        = bool
  default     = true
}

variable "ssl" {
  description = "Set to `false` to disable SSL support."
  type        = bool
  default     = true
}

variable "labels" {
  description = "The labels to attach to resources created by this module"
  type        = map(string)
  default     = {}
}

variable "quic" {
  type        = bool
  description = "Set to `true` to enable QUIC support"
  default     = false
}

variable "private_key" {
  description = "Content of the private SSL key. Required if `ssl`|`https_redirect` are `true` and `ssl_certificates` is empty."
  type        = string
  default     = null
  sensitive   = true
}

variable "certificate" {
  description = "Content of the SSL certificate. Required if `ssl`|`https_redirect` are `true` and `ssl_certificates` is empty."
  type        = string
  default     = null
}

variable "use_ssl_certificates" {
  description = "If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate`"
  type        = bool
  default     = false
}

variable "ssl_certificates" {
  description = "SSL cert self_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided."
  type        = list(string)
  default     = []
}

variable "create_url_map" {
  description = "Set to `false` if url_map variable is provided."
  type        = bool
  default     = true
}

variable "url_map" {
  description = "The url_map resource to use. Default is to send all traffic to first backend."
  type        = string
  default     = null
}

variable "ssl_policy" {
  type        = string
  description = "Selfink to SSL Policy to override DnB's default policy."
  default     = null
}

variable "ssl_profile" {
  description = "SSL Profile. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy"
  type        = string
  default     = "MODERN"
}

variable "ssl_custom_features" {
  description = "List of custom ciphers. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy"
  type        = list(string)
  default     = []
}

variable "create_address" {
  type        = bool
  description = "Create a new internal IPv4 address for ILB."
  default     = true
}

variable "address" {
  type        = string
  description = "Existing IPv4 address to use for ILB (the actual IP address value)"
  default     = null
}

variable "backends" {
  description = "Map backend indices to list of backend maps."
  type = map(object({
    protocol                        = string
    port                            = number
    port_name                       = string
    description                     = optional(string)
    timeout_sec                     = number
    connection_draining_timeout_sec = optional(number)
    session_affinity                = optional(string)
    affinity_cookie_ttl_sec         = optional(number)

    health_check = object({
      check_interval_sec  = optional(number)
      timeout_sec         = optional(number)
      healthy_threshold   = optional(number)
      unhealthy_threshold = optional(number)
      request_path        = string
      port                = number
      host                = optional(string)
      logging             = optional(bool)
    })

    log_config = object({
      enable      = bool
      sample_rate = number
    })

    groups = list(object({
      group = string

      balancing_mode               = optional(string)
      capacity_scaler              = optional(number)
      description                  = optional(string)
      max_connections              = optional(number)
      max_connections_per_instance = optional(number)
      max_connections_per_endpoint = optional(number)
      max_rate                     = optional(number)
      max_rate_per_instance        = optional(number)
      max_rate_per_endpoint        = optional(number)
      max_utilization              = optional(number)
    }))
    iap_config = object({
      enable               = bool
      oauth2_client_id     = optional(string)
      oauth2_client_secret = optional(string)
    })
  }))
}