module "mssql_test" {
  source = "../../../modules/mssql"

  db_name                 = var.db_name
  db_version              = var.db_version
  project_id              = var.project_id
  zone                    = var.zone
  region                  = var.region
  availability_type       = var.availability_type
  db_tier                 = var.db_tier
  disk_size               = var.disk_size
  shared_vpc_id           = var.shared_vpc_id
  allocated_ip_range      = var.allocated_ip_range
  active_directory_config = var.active_directory_config
  database_flags          = var.database_flags
  user_labels             = var.user_labels
  deletion_protection     = var.deletion_protection
}