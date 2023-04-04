output "bucket" {
  description = "The created storage bucket"
  value       = google_storage_bucket.bucket
}

output "versioning" {
  description = "The created storage bucket's versioning status"
  value       = google_storage_bucket.bucket.versioning
}

output "encryption" {
  description = "The created storage bucket's access level"
  value       = google_storage_bucket.bucket.uniform_bucket_level_access
}

output "storage_class" {
  description = "The created storage bucket's storage class"
  value       = google_storage_bucket.bucket.storage_class
}

output "retention_policy" {
  description = "The created storage bucket's retention policy"
  value       = google_storage_bucket.bucket.retention_policy
}

output "not_public" {
  description = "The created storage bucket's public access prevention"
  value       = google_storage_bucket.bucket.public_access_prevention
}

output "storage_notification" {
  description = "The created storage notification self_link for the bucket"
  value = {
    for k, n in google_storage_notification.notification : k => n.self_link
  }
}