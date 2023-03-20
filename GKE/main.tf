module "dnb_gcp_shared_constants" {
  source  = "app.terraform.io/dnb-core/dnb_gcp_shared_constants/google"
  version = "1.8.0"
}

locals {
  host_networking_project_id = tomap(module.dnb_gcp_shared_constants.network.host_networking_project_id)
  master_subnetwork          = tomap(module.dnb_gcp_shared_constants.network.gke_control_plane.master_subnetwork)
  project_subnet_parent_cidr = tomap(module.dnb_gcp_shared_constants.network.shared_vpc.project_subnet_parent_cidr)
  gke_secondary_parent_cidr  = tomap(module.dnb_gcp_shared_constants.network.shared_vpc.gke_secondary_parent_cidr)
  master_authorized_networks = [
    for cidr in module.dnb_gcp_shared_constants.network.ip_ranges.internal :
    {
      cidr_block   = cidr
      display_name = "allowed_gke_access_range"
    }
  ]

  network_tags = {
    all = concat(["gke-node-pool", "aws-https-out"], var.enable_http_lb ? ["ilb-default-rules"] : [])
  }
  register_request_body = {
    name                             = module.kubernetes-engine.name, region = var.region, project = var.project_id,
    action                           = "REGISTER",
    backup_plan_cron_schedule        = var.backup_plan_cron_schedule,
    backup_plan_name                 = var.backup_plan_name,
    backup_retain_days               = var.backup_retain_days,
    restore_plan_name                = var.restore_plan_name,
    volume_data_restore_policy       = var.volume_data_restore_policy,
    namespaced_resource_restore_mode = var.namespaced_resource_restore_mode,
    default_protected_application    = var.default_protected_application,
    cluster_tier                     = random_integer.cluster_tier.result
  }
  register_request_body_string = jsonencode(local.register_request_body)
  anthos_fleet_topic_name      = "anthos-fleet-registration-pubsub-topic"
  anthos_fleet_project_id      = tomap(module.dnb_gcp_shared_constants.anthos_fleet.project_id)
}

module "kubernetes-engine" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant"
  version = "25.0.0"

  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  kubernetes_version         = var.kubernetes_version
  release_channel            = var.release_channel
  service_account            = var.service_account
  network_project_id         = local.host_networking_project_id[var.environment]
  network                    = var.network
  subnetwork                 = var.subnet
  ip_range_pods              = var.secondary_subnet_pods
  ip_range_services          = var.secondary_subnet_services
  http_load_balancing        = var.enable_http_lb
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = var.enable_filestore_csi_driver
  gateway_api_channel        = var.gateway_api_channel
  #If false VPC with the control plane will expose public endpoint for interaction with kubectl API
  #If true I have to come from GCP VPC with /28 cidr
  enable_private_endpoint       = true
  enable_private_nodes          = true
  enable_intranode_visibility   = var.enable_intranode_visibility
  deploy_using_private_endpoint = true
  configure_ip_masq             = true
  master_global_access_enabled  = true
  non_masquerade_cidrs = tolist([
    local.project_subnet_parent_cidr[var.environment], local.gke_secondary_parent_cidr[var.environment]
  ])
  master_authorized_networks = local.master_authorized_networks
  node_metadata              = "GKE_METADATA"
  //mandatory for the private cluster, needs to be unique within a VPC, hardcoded until can be reserved with infoblox
  master_ipv4_cidr_block = infoblox_ipv4_network.gke_control_plane_cidr.cidr
  node_pools             = var.node_pools
  // setting best practices default, so we don't end up with teams using legacy OAuth scopes to restrict access
  // Link: https://cloud.google.com/compute/docs/access/service-accounts#accesscopesiam
  enable_shielded_nodes = true
  node_pools_oauth_scopes = {
    all = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  node_pools_labels                    = var.node_pools_labels
  node_pools_metadata                  = var.node_pools_metadata
  node_pools_taints                    = var.node_pools_taints
  node_pools_tags                      = local.network_tags
  default_max_pods_per_node            = var.default_max_pods_per_node
  config_connector                     = var.config_connector
  gke_backup_agent_config              = var.gke_backup_agent_config
  monitoring_enable_managed_prometheus = var.enable_managed_prometheus
  monitoring_enabled_components        = var.monitoring_enabled_components
}

resource "infoblox_ipv4_network" "gke_control_plane_cidr" {
  provider            = infoblox
  parent_cidr         = local.master_subnetwork[var.environment]
  allocate_prefix_len = 28
  network_view        = "infobloxdunbrad"
  comment             = "gcp/sharedservices/${var.environment}/${var.project_id}/${var.cluster_name}"
}

resource "null_resource" "register_cluster" {
  # limiting this to nonprod only since it's the only env we have anthos fleet so far
  # old clusters will be imported to Prod once we have an anthos-fleet there
  # also adding the variable skip_fleet_registratio to allow skipping it
  count = var.environment == "non_prod" && var.skip_fleet_registration == false ? 1 : 0
  provisioner "local-exec" {
    when        = create
    command     = <<-EOT
      export PUSBSUB_URL="https://pubsub.googleapis.com/v1/projects/${local.anthos_fleet_project_id[var.environment]}/topics/${local.anthos_fleet_topic_name}:publish";
      export POST_MESSAGE="{\"messages\":[{\"data\":\"${base64encode(local.register_request_body_string)}\"}]}";
      printenv GOOGLE_OAUTH_ACCESS_TOKEN | sed -e 's/^/Authorization: Bearer /' > temp;
      STATUS=$(curl -s -o /dev/null -w "%%{http_code}" -X POST "$PUSBSUB_URL" -H 'Content-Type: application/json' -H @temp -d "$POST_MESSAGE");
      rm temp;
      [ $(echo $STATUS | cut -c1-1) -eq 2 ] && exit 0 || exit 1
    EOT
    interpreter = ["/bin/sh", "-c"]
  }

  triggers = {
    cluster_id   = module.kubernetes-engine.cluster_id
    request_body = local.register_request_body_string
  }

  depends_on = [
    module.kubernetes-engine,
    random_integer.cluster_tier
  ]
}

resource "random_integer" "cluster_tier" {
  min = 0
  max = 9
}

module "helm_vault" {
  source            = "app.terraform.io/dnb-core/dnb_vault_agent_helm_release/google"
  version           = "1.0.1"
  name              = var.vault_name
  vault_server_url  = var.vault_server_address
  cluster_namespace = var.vault_namespace
}
