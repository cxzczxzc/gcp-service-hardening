data "http" "devx_rest_api" {
  url = "${var.devx_url}/${var.org}/${var.environment}"
  request_headers = {
    devx-tfc-api-token = var.devx_api_token
  }
}

data "http" "cmdb" {
  url = "${var.cmdb_url}/${var.drn}"
}

locals {
  devx-unfilter   = { for k, v in jsondecode(data.http.devx_rest_api.response_body).environments : k => v }
  devx-map-filter = { for k, v in local.devx-unfilter : k => v if v["project_id"] == var.project_id }
  devx-list       = flatten([for m in local.devx-map-filter : [for k, v in m : v if k == "environment" || k == "drn"]])
  devx-env-label  = [for m in local.devx-map-filter : { for k, v in m : k => v if k == "environment" }]
}

locals {
  cmdb-app      = { for k, v in jsondecode(data.http.cmdb.response_body).data : k => v }
  cmdb-list     = flatten([for k, v in local.cmdb-app : lower(v) if k == "FriendlyName" || k == "DRN"])
  concat-list   = flatten([for i in local.cmdb-list : toset(concat(local.cmdb-list, local.devx-list)) if contains(local.devx-list, i)])
  metadata-tag  = join("-", reverse(sort(local.concat-list)))
  instance-tags = concat(var.instance_tags, [local.metadata-tag])
}

module "module_under_test" {
  source                = "../.."
  project_id            = var.project_id
  region                = var.region
  hostname              = var.hostname
  subnetwork            = var.subnetwork
  subnetwork_project_id = var.subnetwork_project_id
  source_image_type     = var.source_image_type
  health_check = {
    type                = null // health check disabled
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 22
    request             = ""
    request_path        = "/"
    host                = ""
  }
  additional_disks = var.additional_disks
  update_policy = [
    {
      instance_redistribution_type = "NONE"
      type                         = "PROACTIVE"
      minimal_action               = "RESTART"
      max_surge_fixed              = 0
      max_surge_percent            = null
      max_unavailable_fixed        = 3
      max_unavailable_percent      = null
      min_ready_sec                = 50
      replacement_method           = "RECREATE"
    }
  ]
  stateful_disks = var.stateful_disks
  target_size    = 2
  metadata = {
    startup-script = file("../../scripts/linux/adgroups-sudoers-d.sh")
  }
  tags = local.instance-tags
  labels = {
    environment = lookup(local.devx-env-label[0], "environment", "")
  }
  machine_type = "e2-medium"

  os_patch_week_of_the_month  = var.os_patch_week_of_the_month
  os_patch_day_of_the_week    = var.os_patch_day_of_the_week
  os_patch_hours_of_the_day   = var.os_patch_hours_of_the_day
  os_patch_minutes_of_the_day = var.os_patch_minutes_of_the_day
}
