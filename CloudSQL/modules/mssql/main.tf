# TODO add module logic
module "mssql-db" {
  source               = "GoogleCloudPlatform/sql-db/google//modules/mssql"
  version              = "~> 12.0"
  name                 = var.db_name
  random_instance_name = var.random_instance_name
  database_version     = var.db_version
  project_id           = var.project_id
  zone                 = var.zone
  region               = var.region
  availability_type    = var.availability_type
  tier                 = var.db_tier
  disk_size            = var.disk_size
  encryption_key_name  = var.encryption_key_name
  deletion_protection  = var.deletion_protection

  ip_configuration = {
    ipv4_enabled        = false
    private_network     = var.shared_vpc_id
    require_ssl         = var.require_ssl
    allocated_ip_range  = var.allocated_ip_range
    authorized_networks = var.authorized_networks
  }

  active_directory_config = var.active_directory_config
  database_flags          = var.database_flags
  user_labels             = var.user_labels

  create_timeout = var.create_timeout
  update_timeout = var.update_timeout
  delete_timeout = var.delete_timeout
}
