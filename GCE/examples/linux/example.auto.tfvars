project_id                  = "terratest-modules127c1f2e744f8"
region                      = "us-east4"
drn                         = "3316"
hostname                    = "linux-example-app1"
subnetwork                  = "terratest-modules127c1f2e744f8"
subnetwork_project_id       = "host-networking51299c9b7bc30c5"
source_image_type           = "rhel8"
os_patch_week_of_the_month  = 1
os_patch_day_of_the_week    = "SUNDAY"
os_patch_hours_of_the_day   = 12
os_patch_minutes_of_the_day = 0

####### Additional disk ########
additional_disks = [{
  auto_delete = false
  boot        = false
  device_name = "linux-example-app1-stateful-1"
  disk_labels = {
    "key" = "test"
  }
  disk_name    = "linux-example-app1-stateful-1"
  disk_size_gb = 3
  disk_type    = "pd-standard"
}]
/* statefull policy on DISKS */

stateful_disks = [{
  device_name = "linux-example-app1-stateful-1"
  delete_rule = "NEVER"
}]
