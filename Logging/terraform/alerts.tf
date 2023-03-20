# Below IAM binding is to allow users to acknowledge/resolve alerts in the project
resource "google_project_iam_binding" "alert_editing" {
  project = var.project_id
  role    = "roles/monitoring.editor"

  members = [
    "user:gromovd@dnb.com",
    "user:chitturic@dnb.com",
  ]
}

resource "google_monitoring_alert_policy" "alert_policy" {
  for_each = toset( ["org-logs-admin-sub", "org-logs-network-sub", "org-logs-nonprod-sub", "org-logs-prod-sub"] )
  display_name = "${each.key}: Unacked message age over threshold"
  enabled = "true"
  combiner     = "OR"
  conditions {
    display_name = "${each.key}: Unacked message age threshold"
    condition_threshold {
      filter     = "metric.type=\"pubsub.googleapis.com/subscription/oldest_unacked_message_age\" AND resource.type=\"pubsub_subscription\" AND resource.labels.subscription_id=\"${each.key}\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 3600
      trigger {
        count = 1
      }
    }   
  }
  
  alert_strategy  {
    auto_close = "86400s"
  }
  
 notification_channels = [google_monitoring_notification_channel.xmatters.id, google_monitoring_notification_channel.chandra.id, google_monitoring_notification_channel.dima.id ] 
 user_labels = var.labels
}


resource "google_monitoring_notification_channel" "xmatters" {
  display_name = "Notification Channel - XMatters"
  type         = "webhook_tokenauth"
  labels = {
    url = " https://dnb.xmatters.com/api/integration/1/functions/a58f0485-613d-47b6-b168-18aeb8e9af39/triggers?apiKey=da2d1b53-9d6a-4124-86c2-c0488a0c9b67&recipients=GCP-TECHOPS-OBSERVABILITY-OPS"
  }  
}

resource "google_monitoring_notification_channel" "chandra" {
  display_name = "Notification Channel - Chandra"
  type         = "email"
  labels = {
    email_address = "chitturic@dnb.com"
  }
}
resource "google_monitoring_notification_channel" "dima" {
  display_name = "Notification Channel - Dima"
  type         = "email"
  labels = {
    email_address = "gromovd@dnb.com"
  }
}
