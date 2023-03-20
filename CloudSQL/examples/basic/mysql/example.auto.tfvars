db_name               = "module-testing-mysql"
db_version            = "MYSQL_8_0"
project_id            = "terratest-modules127c1f2e744f8"
zone                  = "us-east4-a"
region                = "us-east4"
db_tier               = "db-f1-micro"
disk_size             = 20
network_name          = "nonprod-shared-trust"
shared_vpc_project_id = "host-networking51299c9b7bc30c5"
vpc_id                = "projects/host-networking51299c9b7bc30c5/global/networks/nonprod-shared-trust"
deletion_protection   = false
database_flags = [
  { name = "local_infile", value = "off" },
  { name = "skip_show_database", value = "on" }
]
backup_configuration = {
  "binary_log_enabled" : false
  "enabled" : true,
  "location" : "us-east4",
  "retained_backups" : 7,
  "start_time" : "23:00",
  "point_in_time_recovery_enabled" = false,
  "retention_unit"                 = "COUNT",
  "transaction_log_retention_days" = 7
}
