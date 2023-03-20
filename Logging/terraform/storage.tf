module "dnb_gcp_cloud_storage" {
  source  = "app.terraform.io/dnb-core/dnb_gcp_cloud_storage/google"
  version = "1.1.0"
  environment = "prod"
  project_id =  var.project_id
  location = "us-east4"
  name = "central_logging"
  bucket_versioning = false

}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = "central_logging"
  role = "roles/storage.legacyBucketWriter"
  members = [
    "group:cloud-storage-analytics@google.com",
    "serviceAccount:service-637063186678@gs-project-accounts.iam.gserviceaccount.com",
    "user:chitturic@dnb.com",
  ]
}

# Create bucket that will host the source code for cloud functions
module "dnb_gcp_cloud_storage2" {
  source  = "app.terraform.io/dnb-core/dnb_gcp_cloud_storage/google"
  version = "1.1.0"
  environment = "nonprod"
  project_id =  var.project_id
  location = "us-east4"
  name = "${var.project_id}-function"
}

  resource "google_storage_bucket_iam_binding" "binding2" {
  bucket = "${var.project_id}-function"
  role = "roles/storage.legacyBucketWriter"
  members = [
    "user:chitturic@dnb.com",
  ]
}
