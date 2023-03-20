# Reference document:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy

resource "google_compute_ssl_policy" "global-ssl-policy" {
  count           = var.ssl_policy_global ? 1 : 0
  project         = var.project_id
  name            = var.ssl_policy_name
  profile         = var.ssl_profile
  min_tls_version = var.ssl_min_tls_version
}

# Reference document:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_ssl_policy

resource "google_compute_region_ssl_policy" "regional-ssl-policy" {
  count           = var.ssl_policy_global ? 0 : 1
  provider        = google-beta
  project         = var.project_id
  name            = var.ssl_policy_name
  profile         = var.ssl_profile
  min_tls_version = var.ssl_min_tls_version
  region          = var.region
}