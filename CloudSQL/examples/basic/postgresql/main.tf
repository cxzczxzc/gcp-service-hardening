module "postgresql_test" {
  source = "../../../modules/postgresql"

  db_name               = var.db_name
  db_version            = var.db_version
  project_id            = var.project_id
  zone                  = var.zone
  region                = var.region
  db_tier               = var.db_tier
  disk_size             = var.disk_size
  network_name          = var.network_name
  shared_vpc_project_id = var.shared_vpc_project_id
  vpc_id                = var.vpc_id
  deletion_protection   = var.deletion_protection
  database_flags        = var.database_flags
  backup_configuration  = var.backup_configuration
}
