module "bigquery_validations" {
  source = "../.."

  name        = var.name
  project_id  = var.project_id
  location    = var.location
  environment = var.environment
  log_bucket  = var.log_bucket
}
