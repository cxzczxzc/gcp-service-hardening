resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

#httpFunc
resource "google_storage_bucket" "httpfunc-test-bucket" {
  name          = "${var.httpfunc_source_archive_bucket}-${random_string.random.result}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "httpfunc-test-bucket-object" {
  name   = var.source_archive_object
  source = "main.zip"
  bucket = google_storage_bucket.httpfunc-test-bucket.name
}

module "http_cloudfunction" {
  source                       = "../../../modules/provision_httpfunc"
  project_id                   = var.project_id
  region                       = var.region
  source_archive_bucket        = google_storage_bucket.httpfunc-test-bucket.name
  source_archive_object        = google_storage_bucket_object.httpfunc-test-bucket-object.name
  runtime                      = var.runtime
  available_memory_mb          = var.available_memory_mb
  timeout                      = var.timeout
  entry_point                  = var.entry_point
  min_instances                = var.min_instances
  max_instances                = var.max_instances
  build_environment_variables  = var.build_environment_variables
  environment_variables        = var.environment_variables
  account_id                   = var.httpfunc_account_id
  function-name                = var.httpfunc_function-name
  function-description         = var.httpfunc_function-description
  shared_constants_file        = var.shared_constants_file
  shared_constants_environment = var.shared_constants_environment
  shared_constants_gcs_bucket  = var.shared_constants_gcs_bucket
  shared_constants_region      = var.shared_constants_region
}

#pubsubFunc
resource "google_storage_bucket" "pubsubfunc-test-bucket" {
  name          = "${var.pubsubfunc_source_archive_bucket}-${random_string.random.result}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "pubsubfunc-test-bucket-object" {
  name   = var.source_archive_object
  source = "main.zip"
  bucket = google_storage_bucket.pubsubfunc-test-bucket.name
}

resource "google_pubsub_topic" "pubsubfunc-topic" {
  name    = "${var.pubsubfunc_topic_name}-${random_string.random.result}"
  project = var.project_id
}

module "pubsub_cloudfunction" {
  source                       = "../../../modules/provision_pubsubfunc"
  project_id                   = var.project_id
  region                       = var.region
  source_archive_bucket        = google_storage_bucket.pubsubfunc-test-bucket.name
  source_archive_object        = google_storage_bucket_object.pubsubfunc-test-bucket-object.name
  runtime                      = var.runtime
  available_memory_mb          = var.available_memory_mb
  timeout                      = var.timeout
  entry_point                  = var.entry_point
  min_instances                = var.min_instances
  max_instances                = var.max_instances
  build_environment_variables  = var.build_environment_variables
  environment_variables        = var.environment_variables
  account_id                   = var.pubsubfunc_account_id
  topic_name                   = google_pubsub_topic.pubsubfunc-topic.id
  function-name                = var.pubsubfunc_function-name
  function-description         = var.pubsubfunc_function-description
  shared_constants_file        = var.shared_constants_file
  shared_constants_environment = var.shared_constants_environment
  shared_constants_gcs_bucket  = var.shared_constants_gcs_bucket
  shared_constants_region      = var.shared_constants_region
}

#storageFunc
resource "google_storage_bucket" "storagefunc-test-bucket" {
  name          = "${var.storagefunc_source_archive_bucket}-${random_string.random.result}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "storagefunc-test-bucket-object" {
  name   = var.source_archive_object
  source = "main.zip"
  bucket = google_storage_bucket.storagefunc-test-bucket.name
}

module "storage_cloudfunction" {
  source                       = "../../../modules/provision_storagefunc"
  project_id                   = var.project_id
  region                       = var.region
  source_archive_bucket        = google_storage_bucket.storagefunc-test-bucket.name
  source_archive_object        = google_storage_bucket_object.storagefunc-test-bucket-object.name
  function_trigger_bucket      = google_storage_bucket.storagefunc-test-bucket.name
  runtime                      = var.runtime
  available_memory_mb          = var.available_memory_mb
  timeout                      = var.timeout
  entry_point                  = var.entry_point
  min_instances                = var.min_instances
  max_instances                = var.max_instances
  build_environment_variables  = var.build_environment_variables
  environment_variables        = var.environment_variables
  account_id                   = var.storagefunc_account_id
  function-name                = var.storagefunc_function-name
  function-description         = var.storagefunc_function-description
  shared_constants_file        = var.shared_constants_file
  shared_constants_environment = var.shared_constants_environment
  shared_constants_gcs_bucket  = var.shared_constants_gcs_bucket
  shared_constants_region      = var.shared_constants_region
}
