module "bucket_storage_class_validations" {
  source = "../.."

  name          = "dnb-gcp-cloud-storage-terratest-production-grade"
  project_id    = var.project_id
  location      = var.region
  environment   = var.environment
  storage_class = var.storage_class
  force_destroy = var.force_destroy
}
