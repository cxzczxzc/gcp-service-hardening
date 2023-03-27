output "region" {
  value = var.region
}

output "bucket" {
  description = "The created storage bucket"
  value       = module.bucket_storage_class_validations.bucket.name
}

output "versioning" {
  description = "The created storage bucket's versioning status"
  value       = module.bucket_storage_class_validations.versioning
}

output "storage_class" {
  description = "The created storage bucket's storage class"
  value       = module.bucket_storage_class_validations.storage_class
}

output "retention_policy" {
  description = "The created storage bucket's retention policy"
  value       = module.bucket_storage_class_validations.retention_policy
}