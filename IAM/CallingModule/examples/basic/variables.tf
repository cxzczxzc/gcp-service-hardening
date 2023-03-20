variable "project_id" {
  description = "The project ID of the GCP project this module deploys to"
  type        = string
}

## Making this item a variable allows the same terraform to use different external SA values for each deployment (e.g., nonprod v prod)
variable "terratest_external_sa_email" {
  type        = string
  description = "The email of an existing service account from another GCP project. This usage validates cross project binding"
}

variable "identity_that_is_not_a_service_account" {
  type        = string
  description = "Email of an account other than a service account. This is used to validate that the module would only grant roles to service accounts."
}

variable "service_account_within_project" {
  type        = string
  description = "Email of a service account that exists within a project."
}