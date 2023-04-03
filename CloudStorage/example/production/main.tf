module "bucket_storage_class_validations" {
  source = "../.."

  name          = var.name
  project_id    = var.project_id
  location      = var.location
  environment   = var.environment
  storage_class = var.storage_class
  force_destroy = var.force_destroy
}
