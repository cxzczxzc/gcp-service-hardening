module "kms" {
  source     = "../.."
  project_id = var.project_id
  keyring    = var.keyring
  keys       = var.keys
}
