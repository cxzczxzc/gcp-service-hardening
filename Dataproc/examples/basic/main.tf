# Service account that GCE VMs will be using
# Must be created through shared vpc module call in devx-gcp-lz host-networking folder (main-org)
data "google_service_account" "dataproc_sa" {
  project    = var.project_id
  account_id = "dataproc-sa"
}

# Bucket
module "dp_bucket" {
  source        = "app.terraform.io/dnb-core/dnb_gcp_cloud_storage/google"
  version       = "1.0.0"
  name          = "dnb-dataproc-staging"
  project_id    = var.project_id
  force_destroy = true
  environment   = "nonprod"
}


# Dataproc cluster
module "dp_cluster" {
  source                 = "../../"
  cluster_name           = var.cluster_name
  image_version          = var.image_version
  region                 = var.region
  zone                   = var.zone
  labels                 = var.labels
  project_id             = var.project_id
  staging_bucket         = module.dp_bucket.bucket.name
  host_project_id        = var.host_project_id
  subnetwork             = var.subnetwork
  worker_instance_type   = var.worker_instance_type
  conda_packages         = var.conda_packages
  pip_packages           = var.pip_packages
  optional_components    = var.optional_components
  override_properties    = var.override_properties
  master_instance_type   = var.master_instance_type
  service_account        = data.google_service_account.dataproc_sa.email
  tags                   = var.tags
  service_account_scopes = var.service_account_scopes
}
