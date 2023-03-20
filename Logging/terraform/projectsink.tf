resource "google_logging_project_sink" "nonprod_project_log_sink" {
  name             = "${each.key}-sink2pubsub"
  project          = "${each.key}"
  destination      = "pubsub.googleapis.com/projects/${var.project_id}/topics/org-logs-nonprod-topic"
  exclusions {
    name        = "admin_log_filter"
    description = "Exclude logs from admin"
    filter      = var.admin_log_filter
  }
  exclusions {
    name        = "network_log_filter"
    description = "Exclude logs from network"
    filter      = var.network_log_filter
  }
  unique_writer_identity = true
  # Run loop for each project_id for the environment variable as nonprod  
  for_each = {
    for key, value in jsondecode(data.http.devx_rest_api.body).projects :
    key => value if (contains("${var.sink_project_ids}",  value.project_id)  || value.forward_logs == true) && value.environment != "prod"
  }
}
  
resource "google_logging_project_sink" "prod_project_log_sink" {
  name             = "${each.key}-sink2pubsub"
  project          = "${each.key}"
  destination      = "pubsub.googleapis.com/projects/${var.project_id}/topics/org-logs-prod-topic"
  exclusions {
    name        = "admin_log_filter"
    description = "Exclude logs from admin"
    filter      = var.admin_log_filter
  }
  exclusions {
    name        = "network_log_filter"
    description = "Exclude logs from network"
    filter      = var.network_log_filter
  }
  unique_writer_identity = true
  # Run loop for each project_id for the environment variable as nonprod  
  for_each = {
    for key, value in jsondecode(data.http.devx_rest_api.body).projects :
    key => value if value.environment == "prod"
  }
}
