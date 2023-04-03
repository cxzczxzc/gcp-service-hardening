resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  module_name = var.name != "" ? var.name : "${var.prefix_name}-${random_string.suffix.id}"
}

module "simple_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 3.3"

  name               = local.module_name
  project_id         = var.project_id
  location           = var.location
  storage_class      = var.storage_class
  labels             = var.labels
  bucket_policy_only = true
  versioning         = true
  force_destroy      = var.environment != "prod" ? var.force_destroy : false
  retention_policy   = var.retention_policy
  cors               = var.cors
  encryption         = var.encryption # always enabled, chooses between user managed key and google managed key only

  lifecycle_rules   = var.lifecycle_rules
  iam_members       = var.iam_members
  log_bucket        = "central_logging"
  log_object_prefix = "${var.project_id}/${local.module_name}/lb"
  website           = var.website

  depends_on = [
    null_resource.storage_class_validation
  ]
}


// Currently, Terraform doesn't support variable validation using other variables
// One possible workaround is to use precondition validations with a null_resource
// @see https://github.com/hashicorp/terraform/issues/25609#issuecomment-1136340278
resource "null_resource" "storage_class_validation" {

  triggers = {
    always_run = "${timestamp()}"
  }

  lifecycle {
    precondition {
      condition     = var.environment == "prod" ? var.storage_class == "MULTI_REGIONAL" : true
      error_message = "Validation: storage class for 'prod' environment must be MULTI_REGIONAL."
    }
  }
}


resource "google_storage_notification" "notification" {
  for_each = var.notification_pubsub_topics

  bucket         = module.simple_bucket.bucket.name
  payload_format = "JSON_API_V1"
  topic          = "projects/${var.project_id}/topics/${each.value.topic}"
  event_types    = each.value.notification_events
  depends_on     = [google_pubsub_topic_iam_binding.binding]
}

data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

resource "google_pubsub_topic_iam_binding" "binding" {
  for_each = var.notification_pubsub_topics

  project = var.project_id
  topic   = each.value.topic
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}
