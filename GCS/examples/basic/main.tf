locals {
  topics = {
    notification-topic-1 : {
      name                = "notification-topic-1"
      notification_events = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
    }
    notification-topic-2 : {
      name                = "notification-topic-2"
      notification_events = ["OBJECT_ARCHIVE"]
    }
  }
}

module "module_under_test_name" {
  source = "../.."

  name          = "dnb-gcp-cloud-storage-terratest-bucket-use-name"
  project_id    = var.project_id
  location      = var.region
  environment   = var.environment
  force_destroy = var.force_destroy
  notification_pubsub_topics = {
    for k, value in google_pubsub_topic.notification : k => {
      topic : value.name
      notification_events : local.topics[value.name].notification_events
    }
  }
}

resource "google_pubsub_topic" "notification" {
  for_each = local.topics

  name    = each.value.name
  project = var.project_id
}

module "module_under_test_prefix_name" {
  source = "../.."

  prefix_name   = "dnb-gcp-cloud-storage-terratest-bucket"
  project_id    = var.project_id
  location      = var.region
  environment   = var.environment
  force_destroy = var.force_destroy
  notification_pubsub_topics = {
    for k, value in google_pubsub_topic.notification : k => {
      topic : value.name
      notification_events : local.topics[value.name].notification_events
    }
  }
}
