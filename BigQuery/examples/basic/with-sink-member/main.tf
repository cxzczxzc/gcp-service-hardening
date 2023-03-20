module "bigquery_tables" {
  source                   = "../../../"
  dataset_id               = var.dataset_id
  dataset_name             = var.dataset_id
  description              = var.description
  project_id               = var.project_id
  location                 = var.location
  dataset_labels           = var.dataset_labels
  local_value              = var.local_value
  log_sink_writer_identity = var.log_sink_writer_identity
  tables = [
    {
      table_id           = "test",
      schema             = file("schema.json"),
      time_partitioning  = null,
      range_partitioning = null,
      clustering         = [],
      expiration_time    = 2524604400000, # 2050/01/01
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      },
    }
  ]
}
