output "bigquery_dataset" {
  value       = module.bigquery.bigquery_dataset
  description = "Bigquery dataset resource."
}

output "bigquery_tables" {
  value       = module.bigquery.bigquery_tables
  description = "Map of bigquery table resources being provisioned."
}

output "destination_uri" {
  description = "The destination URI for the bigquery dataset."
  value       = local.destination_uri
}
