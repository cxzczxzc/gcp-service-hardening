variable "project_id" {
  type        = string
  default     = ""
  description = "The project in which the bindings will be made. If not given, the provider project ID will be used."
}


variable "service_account_bindings" {
  type = map(object({
    roles                 = list(string)
    service_account_email = string

    condition = optional(object({
      expression  = string
      title       = string
      description = optional(string)
    }))
  }))
  default = {}
}


