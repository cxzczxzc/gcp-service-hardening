# Org level aggregating sinks

resource "google_logging_organization_sink" "organization_log_sink_admin" {
  name             = "${var.admin_pipeline}-sink2pubsub"
  org_id           = var.org_id
  destination      = "pubsub.googleapis.com/${module.logs-admin.topic_id}"
  filter           = var.admin_log_filter
  include_children = true
  # disabled = true
  exclusions {
    name        = "admin_log_excl_filter"
    description = "Exclude data_access events from Cloud Audit"
    filter      = var.admin_log_excl_filter 
  }  
}

resource "google_logging_organization_sink" "organization_log_sink_network" {
  name             = "${var.network_pipeline}-sink2pubsub"
  org_id           = var.org_id
  destination      = "pubsub.googleapis.com/${module.logs-network.topic_id}"
  filter           = var.network_log_filter
  include_children = true
  # disabled = true
}

