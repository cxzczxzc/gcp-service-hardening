locals {
  destination_uri = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${var.dataset_name}"
}

module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 5.4.0"

  dataset_id                 = var.dataset_id
  dataset_name               = var.dataset_name
  description                = var.description
  project_id                 = var.project_id
  location                   = var.location
  delete_contents_on_destroy = var.delete_contents_on_destroy
  tables                     = var.tables
  access                     = var.access
  views                      = var.views
  materialized_views         = var.materialized_views
  external_tables            = var.external_tables
  routines                   = var.routines
  dataset_labels             = var.dataset_labels
}

resource "google_project_iam_member" "bigquery_sink_member" {
  count   = var.local_value == true ? 1 : 0
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = var.log_sink_writer_identity

  depends_on = [
    module.bigquery
  ]
}

