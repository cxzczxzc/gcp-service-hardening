region                   = "us-east4"
project_id               = "terratest-modules127c1f2e744f8"
dataset_id               = "test_bigq_new_feature_sink"
dataset_name             = "test_bigq_new_feature1_sink"
description              = "BigQuery Module testing"
location                 = "US"
local_value              = true
log_sink_writer_identity = "serviceAccount:cloud-logs@system.gserviceaccount.com"
dataset_labels = {
  env      = "dev"
  billable = "true"
}


