module "bigquery_validations" {
  source = "../.."

  dataset_id  = var.dataset_id
  project_id  = var.project_id
  location    = var.location
}
