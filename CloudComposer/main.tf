locals {
  tags              = ["gke-node-pool", "gcp-composer", "aws-https-out"]
  master_subnetwork = tomap(module.dnb_gcp_shared_constants.network.gke_control_plane.master_subnetwork)
  master_authorized_networks = [
    for cidr in module.dnb_gcp_shared_constants.network.ip_ranges.internal :
    {
      cidr_block   = cidr
      display_name = "allowed_gke_access_range"
    }
  ]

  # Enforce DAG per-folder roles, secret manager backend and use of Application Default Credentials (ADC)
  enforced_airflow_config_overrides = {
    webserver-rbac_autoregister_per_folder_roles = "True"
    webserver-rbac_user_registration_role        = "UserNoDags"
    secrets-backend                              = "airflow.providers.google.cloud.secrets.secret_manager.CloudSecretManagerBackend"
    secrets-backend_kwargs = jsonencode({
      project_id = var.project_id
    })
    api-google_key_path = ""
  }
  airflow_config_overrides = merge(var.airflow_config_overrides, local.enforced_airflow_config_overrides)
}

module "dnb_gcp_shared_constants" {
  source  = "app.terraform.io/dnb-core/dnb_gcp_shared_constants/google"
  version = "1.6.0"
}

## Service Account 
module "service_accounts" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.1"
  project_id = var.project_id
  names      = [var.service_account_name]
  project_roles = [
    "${var.project_id}=>roles/composer.ServiceAgentV2Ext",
    "${var.project_id}=>roles/composer.worker",
    "${var.project_id}=>roles/secretmanager.secretAccessor",
    "${var.project_id}=>roles/iam.serviceAccountUser",
  ]
}

resource "google_service_account_iam_member" "composer_agent_access" {
  service_account_id = module.service_accounts.service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_project_service_identity.composer_agent.email}"
}

resource "google_project_service_identity" "composer_agent" {
  provider = google-beta
  project  = var.project_id
  service  = "composer.googleapis.com"
  depends_on = [
    module.composer
  ]
}


module "composer" {
  source  = "terraform-google-modules/composer/google//modules/create_environment_v2"
  version = "~> 3.3.0"

  project_id                             = var.project_id
  region                                 = var.region
  composer_env_name                      = var.composer_env_name
  use_private_environment                = true
  network                                = var.network
  subnetwork                             = var.subnetwork
  grant_sa_agent_permission              = true
  image_version                          = var.image_version
  pod_ip_allocation_range_name           = var.pod_ip_allocation_range_name
  network_project_id                     = var.network_project_id
  service_ip_allocation_range_name       = var.service_ip_allocation_range_name
  composer_service_account               = module.service_accounts.service_account.email
  environment_size                       = var.environment_size
  scheduler                              = var.scheduler
  web_server                             = var.web_server
  worker                                 = var.worker
  cloud_composer_network_ipv4_cidr_block = var.cloud_composer_network_ipv4_cidr_block
  cloud_sql_ipv4_cidr                    = var.cloud_sql_ipv4_cidr
  master_ipv4_cidr                       = infoblox_ipv4_network.cloud_composer_cidr.cidr
  tags                                   = length(var.additional_network_tags) > 0 ? concat(local.tags, var.additional_network_tags) : local.tags
  airflow_config_overrides               = local.airflow_config_overrides
  pypi_packages                          = var.pypi_packages
  env_variables                          = var.env_variables
  enable_private_endpoint                = true
  master_authorized_networks             = local.master_authorized_networks
  enable_ip_masq_agent                   = var.enable_ip_masq_agent
  cloud_composer_connection_subnetwork   = var.cloud_composer_connection_subnetwork != null ? var.cloud_composer_connection_subnetwork : data.google_compute_subnetwork.my-subnetwork.id
}

data "google_compute_subnetwork" "my-subnetwork" {
  name    = var.subnetwork
  region  = var.region
  project = var.project_id
}

resource "infoblox_ipv4_network" "cloud_composer_cidr" {
  provider            = infoblox
  parent_cidr         = local.master_subnetwork[var.environment]
  allocate_prefix_len = 28
  network_view        = "infobloxdunbrad"
  comment             = "gcp/sharedservices/${var.environment}/${var.project_id}/${var.composer_env_name}"
}