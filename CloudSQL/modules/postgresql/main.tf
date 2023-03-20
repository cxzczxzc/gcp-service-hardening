# TODO add module logic
module "postgresql-db" {
  source                  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version                 = "11.0.0"
  name                    = var.db_name
  random_instance_name    = var.random_instance_name
  database_version        = var.db_version
  project_id              = var.project_id
  zone                    = var.zone
  region                  = var.region
  tier                    = var.db_tier
  disk_size               = var.disk_size
  encryption_key_name     = var.encryption_key_name
  deletion_protection     = var.deletion_protection
  database_flags          = var.database_flags
  backup_configuration    = var.backup_configuration
  maintenance_window_day  = var.maintenance_window_day
  maintenance_window_hour = var.maintenance_window_hour
  availability_type       = var.availability_type

  ip_configuration = {
    ipv4_enabled        = false
    private_network     = var.vpc_id
    require_ssl         = var.require_ssl
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }

  create_timeout = var.create_timeout
  update_timeout = var.update_timeout
  delete_timeout = var.delete_timeout
}
