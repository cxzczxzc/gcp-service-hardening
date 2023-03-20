## Get reference to current project's name
data "google_client_config" "default" {}

data "google_project" "current_project" {
  project_id = data.google_client_config.default.project
}

module "dnb_gcp_project_iam" {
  # This this usage calls the local module code. To use in your own terraoform project, use the following commented lines instead

  # source = "app.terraform.io/dnb-core/dnb_gcp_project_iam"
  # version = "0.1.0"
  source = "../.."

  # [Optional] You can specify which project the bindings wil be applied in. If not given, the provider
  # project_id will be utilized
  #  
  # project_id = var.project_id

  service_account_bindings = {
    # Create a list of bindings for service accounts and provide the sa email and role
    #
    # * The key (e.g., container-admin-until-october-sa1) for each binding object should be an expressive name 
    #     for the binding and will be helpful to identify and debug resources in the terraform state if needed

    # The roles that can be used are defined by the environment in which you are deploying to in the DevX GCP platform. This 
    # configuration is currently defined in the landing zone repo:
    # https://github.com/dnb-main/devx-gcp-lz/tree/main/terraform/devx-gcp-landingzone-project-vending/modules/gcp_iam_delegated_role_grants 
    # Here you will be able to find the list of allowed roles that are compatible with this module

    # [OPTIONAL] include an IAM condition for the role binding. Format is defined in terraform google provider docs
    container-admin-until-october-sa1 = {
      service_account_email = var.service_account_within_project
      roles                 = ["roles/container.admin"]
      condition = {
        expression  = "request.time < timestamp(\"2022-10-01T00:00:00Z\")"
        title       = "expire_end_september"
        description = "Role access expires at the end of September 2020"

      }
    },
    # [OPTIONAL] bind multiple roles at a time to a service account
    container-roles-for-sa2 = {
      service_account_email = var.service_account_within_project
      roles                 = ["roles/container.admin", "roles/container.developer"]
    }
    # Note - you can create two bindings for the same entity (see container-admin-until-october-sa1 above)
    bigquery-sa1-data-access = {
      service_account_email = var.service_account_within_project
      roles                 = ["roles/bigquery.dataViewer"]
    }
    # This module enables you to bind roles to existing service accounts that belong to another project in the same org
    external_project_sa = {
      service_account_email = var.terratest_external_sa_email
      roles                 = ["roles/bigquery.dataViewer"]
    }
    # This is used to validate that role grants work if and only if the type of identity is a 
    # service account, i.e., ends with the suffix ".gserviceaccount.com"
    not_a_service_account = {
      service_account_email = var.identity_that_is_not_a_service_account
      roles                 = ["roles/storage.objectAdmin"]
    }
  }
}
