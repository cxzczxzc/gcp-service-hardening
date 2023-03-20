region                = "us-east4"
project_id            = "terratest-modules127c1f2e744f8"
runtime               = "python37"
available_memory_mb   = 128
entry_point           = "hello_gcs"
timeout               = 60
source_archive_object = "main.zip"
min_instances         = 1
max_instances         = 2
build_environment_variables = {
  DATABASE_NAME : "TEST"
  PYTHON_VERSION : "3.7"
}
environment_variables = {
  APP_ENV : "DEV"
  REDIS_ID : "CACHE"
}

#httpFunc
httpfunc_account_id            = "test-http-cf-sa"
httpfunc_function-name         = "http-function"
httpfunc_function-description  = "To test http function"
httpfunc_source_archive_bucket = "http_cloudfunc_bucket"

#pubsubFunc
pubsubfunc_account_id            = "test-pubsub-cf-sa"
pubsubfunc_topic_name            = "test-pubsub-cf-topic"
pubsubfunc_function-name         = "pubsub-function"
pubsubfunc_function-description  = "To test pubsub function"
pubsubfunc_source_archive_bucket = "pubsub_cloudfunc_bucket"

#storageFunc
storagefunc_account_id            = "test-storage-cf-sa"
storagefunc_function-name         = "storage-function"
storagefunc_function-description  = "To test storage function"
storagefunc_source_archive_bucket = "storage_bucket"

#shared_constants
shared_constants_environment = "nonprod"
shared_constants_gcs_bucket  = "networking-constants-host-networking51299c9b7bc30c5"
shared_constants_region      = "north-america"
