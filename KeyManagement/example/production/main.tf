module "kms" {
  source     = "../.."
  project_id = var.project_id
  location   = var.location
  keyring    = var.keyring
}

