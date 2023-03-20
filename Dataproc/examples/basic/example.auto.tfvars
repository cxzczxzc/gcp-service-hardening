
region               = "us-east4"
zone                 = "us-east4-b"
project_id           = "terratest-tf-gcp-dataprocfe910"
host_project_id      = "host-networking51299c9b7bc30c5"
subnetwork           = "terratest-tf-gcp-dataprocfe910"
worker_instance_type = "n2-standard-4"
master_instance_type = "n2-standard-4"
conda_packages       = "pandas=0.23.4 scikit-learn=0.20.0 pytest=3.8.0 pyyaml=3.13"
pip_packages         = "gensim==3.7.1 logdecorator==2.1"
optional_components  = ["HBASE", "ZOOKEEPER"]
override_properties = {
  "spark:spark.submit.deployMode"                                   = "cluster"
  "dataproc:dataproc.logging.stackdriver.job.driver.enable"         = "true"
  "dataproc:dataproc.logging.stackdriver.job.yarn.container.enable" = "true"
  "dataproc:dataproc.logging.stackdriver.enable"                    = "true"
  "dataproc:jobs.file-backed-output.enable"                         = "true"
}
cluster_name  = "dataproc-cluster-test"
image_version = "2.0" # 2.0.35-debian10
labels = {
  "name" = "dataproc-cluster-module"
}
tags                   = ["gke-com-dnb-dap-gke", "gke-com-dnb-dap-gke-8c7565ac-node", "gke-com-dnb-dap-gke-custom-node-pool", "ssh-in"]
service_account_scopes = ["bigquery", "pubsub", "storage-full", "logging-write"]