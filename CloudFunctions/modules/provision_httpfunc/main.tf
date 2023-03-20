locals {
  vpc_connector_name = module.dnb_gcp_shared_constants.network.vpc_connectors.pod0[var.region]
}

module "dnb_gcp_shared_constants" {
  source         = "app.terraform.io/dnb-core/dnb_gcp_shared_constants/google"
  version        = "2.1.1"
  constants_file = var.shared_constants_file
  environment    = var.shared_constants_environment
  gcs_bucket     = var.shared_constants_gcs_bucket
  region         = var.shared_constants_region
}

# Service account creation
resource "google_service_account" "cloud_function_service_account" {
  project    = var.project_id
  account_id = var.account_id
}

# IAM entry for service account to invoke the http function
resource "google_cloudfunctions_function_iam_member" "httpinvoker" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.httpfunction.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.cloud_function_service_account.email}"

  depends_on = [
    google_cloudfunctions_function.httpfunction
  ]
}

resource "google_cloudfunctions_function" "httpfunction" {
  name                          = var.function-name
  project                       = var.project_id
  region                        = var.region
  description                   = var.function-description
  runtime                       = var.runtime
  available_memory_mb           = var.available_memory_mb
  source_archive_bucket         = var.source_archive_bucket
  source_archive_object         = var.source_archive_object
  trigger_http                  = true
  https_trigger_security_level  = "SECURE_ALWAYS"
  timeout                       = var.timeout
  entry_point                   = var.entry_point
  ingress_settings              = var.ingress_settings
  vpc_connector_egress_settings = var.vpc_connector_egress_settings
  vpc_connector                 = local.vpc_connector_name
  max_instances                 = var.max_instances
  min_instances                 = var.min_instances
  service_account_email         = var.service_account_email
  environment_variables         = var.environment_variables
  build_environment_variables   = var.build_environment_variables

  dynamic "secret_environment_variables" {
    for_each = var.secret_environment_variables

    content {
      key        = lookup(each.value, name, null)
      project_id = lookup(each.value, project_id, null)
      version    = lookup(each.value, version, null)
      secret     = lookup(each.value, secret, null)
    }
  }
}

// Currently, Terraform doesn't support variable validation using other variables
// One possible workaround is to use precondition validations with a null_resource
// @see https://github.com/hashicorp/terraform/issues/25609#issuecomment-1136340278
resource "null_resource" "service_account_email_validation" {

  triggers = {
    always_run = "${timestamp()}"
  }

  lifecycle {
    precondition {
      condition     = var.environment == "prod" ? var.service_account_email != null : true
      error_message = "Validation: service account email must be provided for Prod environment."
    }
  }
}
