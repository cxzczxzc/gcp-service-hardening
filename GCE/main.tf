// enable gce API for the project
resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = false
  disable_on_destroy         = false
}

module "dnb_gcp_shared_constants" {
  source  = "app.terraform.io/dnb-core/dnb_gcp_shared_constants/google"
  version = "1.8.0"
}

locals {
  cis_images_project_id = tomap(module.dnb_gcp_shared_constants.cis_images.project_id)
  cis_images_region     = tomap(module.dnb_gcp_shared_constants.cis_images.region)
  # only ASCII letters, numbers, and hyphens are allowed in packer channel names. This removes _
  hcp_packer_channel = replace(var.environment, "_", "")

  # startup scripts
  win2019_metadata = {
    windows-startup-script-ps1 = file("${path.module}/scripts/startup.ps1")
  }
  rhel8_metadata = {
    startup-script = file("${path.module}/scripts/startup.sh")
  }
}

// use default service account
data "google_compute_default_service_account" "default" {
  project    = var.project_id
  depends_on = [google_project_service.compute]
}

data "hcp_packer_iteration" "image" {
  bucket_name = "platform-${var.source_image_type}-base"
  channel     = local.hcp_packer_channel
}

data "hcp_packer_image" "image" {
  bucket_name    = "platform-${var.source_image_type}-base"
  cloud_provider = "gce"
  iteration_id   = data.hcp_packer_iteration.image.ulid
  region         = local.cis_images_region[var.environment] # note that region here is actually a ZONE.
}

# Attribution, large copy-paste from: https://raw.githubusercontent.com/terraform-google-modules/terraform-google-vm/master/examples/mig/full/main.tf
module "instance_template" {
  source         = "terraform-google-modules/vm/google//modules/instance_template"
  version        = "7.9.0"
  name_prefix    = "${var.hostname}-instance-template"
  project_id     = var.project_id
  region         = var.region
  machine_type   = var.machine_type
  tags           = var.tags
  labels         = var.labels
  startup_script = var.startup_script
  metadata       = var.source_image_type == "rhel8" ? merge(local.rhel8_metadata, var.metadata) : merge(local.win2019_metadata, var.metadata)
  service_account = {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  /* security */
  enable_shielded_vm = true

  /* network */
  network            = null
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project_id
  can_ip_forward     = false

  /* image */
  source_image         = var.source_image != "" ? var.source_image : data.hcp_packer_image.image.cloud_image_id
  source_image_family  = var.source_image_family != "" ? var.source_image_family : "runtimes-cis-${var.source_image_type}-l1"
  source_image_project = var.source_image_project != "" ? var.source_image_project : local.cis_images_project_id[var.environment]

  /* disks */
  disk_size_gb     = var.disk_size_gb
  disk_type        = var.disk_type
  disk_labels      = var.disk_labels
  auto_delete      = var.auto_delete
  additional_disks = var.additional_disks

  /* dependencies */
  depends_on = [google_project_service.compute]
}

module "mig" {
  source                    = "terraform-google-modules/vm/google//modules/mig"
  version                   = "7.6.0"
  project_id                = var.project_id
  hostname                  = var.hostname
  region                    = var.region
  instance_template         = module.instance_template.self_link
  target_size               = var.target_size
  target_pools              = var.target_pools
  distribution_policy_zones = var.distribution_policy_zones
  update_policy             = var.update_policy
  named_ports               = var.named_ports

  /* health check */
  health_check = var.health_check

  /*stateful policy on Disk*/
  stateful_disks = var.stateful_disks

  /* autoscaler */
  autoscaling_enabled          = var.autoscaling_enabled
  max_replicas                 = var.max_replicas
  min_replicas                 = var.min_replicas
  cooldown_period              = var.cooldown_period
  autoscaling_cpu              = var.autoscaling_cpu
  autoscaling_metric           = var.autoscaling_metric
  autoscaling_lb               = var.autoscaling_lb
  autoscaling_scale_in_control = var.autoscaling_scale_in_control

  /* dependencies */
  depends_on = [google_project_service.compute]
}

# Creates a Patch Schedule
module "dnb_gcp_os_config_patch_deployment" {
  source  = "app.terraform.io/dnb-core/dnb_gcp_os_config_patch_deployment/google"
  version = "0.1.0"
  count   = var.enable_os_patch_deployment ? 1 : 0

  project_id                    = var.project_id
  patch_deployment_id           = var.os_patch_deployment_id != "" ? var.os_patch_deployment_id : "${var.hostname}"
  apply_to_all_instances        = false
  filter_instance_name_prefixes = [var.hostname]
  os_patch_week_of_the_month    = var.os_patch_week_of_the_month
  os_patch_day_of_the_week      = var.os_patch_day_of_the_week
  os_patch_hours_of_the_day     = var.os_patch_hours_of_the_day
  os_patch_minutes_of_the_day   = var.os_patch_minutes_of_the_day
}