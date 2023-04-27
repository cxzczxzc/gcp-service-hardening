module "bigquery" {
  source       = "../.."
  dataset_id   = var.dataset_name
  dataset_name = var.dataset_name
  project_id   = var.project_id
  tables       = var.tables

  views = var.views
}