module "module_under_test" {
  source                = "../.."
  project_id            = var.project_id
  region                = var.region
  hostname              = var.hostname
  subnetwork            = var.subnetwork
  subnetwork_project_id = var.subnetwork_project_id
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
  startup_script = ""
  target_size    = 2
  tags           = ["ssh-in"]
  labels = {
    environment = "dev"
  }
  machine_type = "e2-medium"

  os_patch_week_of_the_month  = var.os_patch_week_of_the_month
  os_patch_day_of_the_week    = var.os_patch_day_of_the_week
  os_patch_hours_of_the_day   = var.os_patch_hours_of_the_day
  os_patch_minutes_of_the_day = var.os_patch_minutes_of_the_day
}
