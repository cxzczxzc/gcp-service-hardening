variable "exception_group" {
  description = "This group will be assigned roles that are edge cases/exceptions"
  type        = string
}

variable "exception_roles" {
  description = "A list of roles that would be assigned to a group on exception basis, to enable console access to certain services"
  type        = list(string)
  default     = ["roles/datastore.owner"]
}

variable "project_id" {
  description = "GCP project id of DAP Projects"
  type        = string
}