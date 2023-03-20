variable "project_id" {
  description = "The GCP project id the terraform will be run in the context of"
  type        = string
}

variable "environment" {
  type        = string
  description = "The string value of the environment to deploy DRG to"
}

variable "devx_projects_base_url" {
  type        = string
  description = "Base URL of devx api to acquire vended project info"
}

variable "devx_api_token" {
  type        = string
  description = "The secret token for access to DevX rest API"
  default     = "password"
}

variable "drg_enabled_projects" {
  description = "A list of projects that will have the DRG IAM feature available"
  type        = list(string)
  default     = []
}

variable "direct_role_grants" {
  description = "The list of roles to be granted to the devx service account directly"
  type        = list(string)
  default     = []
}

variable "viewer_group_role_assignment" {
  description = "List of roles assigned to the viewer group at the project level"
  type        = list(string)
  default     = []
}

variable "delegated_role_grants" {
  description = "The list of roles the devx service account will be able to grant to other priciples within the given project"
  type        = list(string)
  default     = []
}

variable "dap_projects" {
  description = "List of DAP projects. These projects are assigned additional Firestore roles, as an exception"
  type        = list(string)
  default     = []
}

variable "dap_exception_group" {
  description = "The group which would be assigned exception role(s) for DAP projects"
  type        = string
}

variable "exception_roles_for_DAP" {
  description = "A list of roles that would be assigned to a DAP group, to enable console access to certain services"
  type        = list(string)
  default     = []
}
