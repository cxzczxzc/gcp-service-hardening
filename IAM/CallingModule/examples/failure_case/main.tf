## This example intends to show a case where role application is expected to fail
# We attempt to apply a role that is known to not be on the approved list for the environment
# Running this terraform should produce a runtime error


## Get reference to current project's name
data "google_client_config" "default" {}

data "google_project" "current_project" {
  project_id = data.google_client_config.default.project
}

module "gcp_project_iam" {
  source = "../.."

  project_id = var.project_id
  service_account_bindings = {
    container-admin-until-october-sa1 = {
      service_account_email = "nprd-gke-workload-id-testd36f8@appspot.gserviceaccount.com"
      roles                 = ["roles/cloudiot.admin"]
      condition = {
        expression  = "request.time < timestamp(\"2022-10-01T00:00:00Z\")"
        title       = "expire_end_september"
        description = "Role access expires at the end of September 2020"

      }
    }
  }
}
