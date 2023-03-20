# any resources acccept labels here?

resource "google_pubsub_topic" "cribl_pubsub_topic" {
  name   = "${var.pipeline_id}-topic"
  labels = var.labels
}

resource "google_pubsub_subscription" "cribl_pubsub_sub" {
  name  = "${var.pipeline_id}-sub"
  topic = google_pubsub_topic.cribl_pubsub_topic.name

  # messages retained for 7 days (max)
  message_retention_duration = "604800s" # max 7 days = 604800s
  ack_deadline_seconds       = 30        # max 600 sec, may need to increase here
  enable_message_ordering    = false

  # subscription never expires
  expiration_policy {
    ttl = ""
  }
  labels = var.labels
}

# Publisher permissions
resource "google_pubsub_topic_iam_binding" "pubsub_iam_topic_binding" {
  topic   = google_pubsub_topic.cribl_pubsub_topic.name
  role    = "roles/pubsub.publisher"
  members = var.topic_writer_identity
}

# Subscriber permissions 
resource "google_pubsub_subscription_iam_binding" "pubsub_iam_sub_binding_subscriber" {
  subscription = google_pubsub_subscription.cribl_pubsub_sub.name
  role         = "roles/pubsub.subscriber"
  members = [
    "serviceAccount:${var.service_account}"
  ]
}

resource "google_pubsub_subscription_iam_binding" "pubsub_iam_sub_binding_viewer" {
  subscription = google_pubsub_subscription.cribl_pubsub_sub.name
  role         = "roles/pubsub.viewer"
  members = [
    "serviceAccount:${var.service_account}"
  ]
}
