output "region" {
  value = var.region
}

output "bucket" {
  description = "The created storage bucket"
  value       = module.module_under_test_name.bucket.name
}

output "versioning" {
  description = "The created storage bucket's versioning status"
  value       = module.module_under_test_name.versioning
}

output "storage_class" {
  description = "The created storage bucket's storage class"
  value       = module.module_under_test_name.storage_class
}

output "retention_policy" {
  description = "The created storage bucket's retention policy"
  value       = module.module_under_test_name.retention_policy
}

output "storage_notification" {
  description = "The created storage notification self_link for the bucket"
  value       = module.module_under_test_name.storage_notification
}
