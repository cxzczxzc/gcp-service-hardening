# Pull project list from devx portal
data "http" "devx_rest_api" {
  url = "https://devx-portal.inf.dnb.net/terraform/v2/GoogleProjects" 
  request_headers = {
    devx-tfc-api-token = var.devx-tfc-api-token
  }
  lifecycle {
    postcondition {
      condition     = contains([201, 204, 200], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

locals {
  nonprod_members_org = [
    for e in jsondecode(data.http.devx_rest_api.body).projects :
    google_logging_project_sink.nonprod_project_log_sink[e.project_id].writer_identity if (contains("${var.sink_project_ids}", e.project_id)  || e.forward_logs == true) && e.environment != "prod"
  ]
  prod_members_org = [
    for e in jsondecode(data.http.devx_rest_api.body).projects :
    google_logging_project_sink.prod_project_log_sink[e.project_id].writer_identity if e.environment == "prod"
  ]
}

locals {    
  nonprod_members =  length(local.nonprod_members_org) == 0 ? ["domain:dnb.com"] : local.nonprod_members_org
  prod_members =  length(local.prod_members_org) == 0 ? ["domain:dnb.com"] : local.prod_members_org
}
    
# using module to create PubSub resources
module "logs-admin" {
  source = "./modules/pubsub4cribl"

  service_account       = google_service_account.cribl_service_account.email
  pipeline_id           = var.admin_pipeline
  topic_writer_identity = [google_logging_organization_sink.organization_log_sink_admin.writer_identity]
  labels                = var.labels
}

module "logs-network" {
  source = "./modules/pubsub4cribl"

  service_account       = google_service_account.cribl_service_account.email
  pipeline_id           = var.network_pipeline
  topic_writer_identity = [google_logging_organization_sink.organization_log_sink_network.writer_identity]
  labels                = var.labels
}

module "logs-nonprod" {
  source = "./modules/pubsub4cribl"

  service_account       = google_service_account.cribl_service_account.email
  pipeline_id           = var.nonprod_pipeline
  topic_writer_identity = local.nonprod_members
  labels                = var.labels
}

module "logs-prod" {
  source = "./modules/pubsub4cribl"

  service_account       = google_service_account.cribl_service_account.email
  pipeline_id           = var.prod_pipeline
  topic_writer_identity = local.prod_members
  labels                = var.labels
}
