variable "project_id" {
  type        = string
  description = "Project where the Dataproc cluster will be created"
}

variable "host_project_id" {
  type        = string
  description = "Project where the Shared VPC is located"
}

variable "region" {
  type        = string
  description = "GCP region where the cluster will be located"
}

variable "zone" {
  type        = string
  description = "GCP zone where the cluster will be located"
}


# DataProc cluster configuration
variable "cluster_name" {
  type        = string
  description = "The name of the DataProc cluster to be created"
}

variable "subnetwork" {
  type        = string
  description = "Name of the subnetwork that the GCE VMs will be using. Must be part of the Shared VPC on the host project"
}

variable "service_account" {
  type        = string
  description = "The service account for the cluster"
  default     = ""
}

variable "service_account_scopes" {
  type        = list(string)
  description = "The set of Google API scopes to be made available on all of the node VMs"
  default     = []
}

variable "staging_bucket" {
  type        = string
  description = "The id of the bucket to be used for staging"
}

variable "image_version" {
  type        = string
  description = "The image version of DataProc to be used, review https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-versions and here https://github.com/GoogleCloudDataproc/custom-images"
  default     = "2.0.51-debian10"
}

variable "optional_components" {
  type        = list(string)
  description = "The optional softwares that need to be installed part of dataproc cluster provisioning. For example ZOOKEEPER,HIVE_WEBHCAT,HBASE,SOLR]"
  default     = []
}

variable "override_properties" {
  type        = map(string)
  description = "The overrite properries that need to be set to dataproc cluster"
  default     = {}
}

variable "master_instance_type" {
  type        = string
  description = "The instance type of the master node"
  default     = "n1-standard-4"
}

variable "master_disk_type" {
  type        = string
  description = "The disk type of the primary disk attached to each master node. One of 'pd-ssd' or 'pd-standard'."
  default     = "pd-standard"
}

variable "master_disk_size" {
  type        = number
  description = "Size of the primary disk attached to each master node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, it also contains the HDFS data blocks and Hadoop working directories."
  default     = 100
}

variable "master_local_ssd" {
  type        = number
  description = "The amount of local SSD disks that will be attached to each master cluster node."
  default     = 0
}

variable "master_ha" {
  type        = bool
  description = "Set to 'true' to enable 3 master nodes (HA) or 'false' for only 1 master node"
  default     = false
}

variable "worker_instance_type" {
  type        = string
  description = "The instance type of the worker nodes"
  default     = "n1-standard-4"
}

variable "primary_worker_min_instances" {
  type        = number
  description = "The minimum number of primary worker instances"
  default     = 2
}

variable "primary_worker_max_instances" {
  type        = number
  description = "The maximum number of primary worker instances"
  default     = 10
}

variable "preemptible_worker_instance_type" {
  type        = string
  description = "The instance type of the secondary worker nodes"
  default     = "n1-standard-4"
}

variable "preemptible_worker_min_instances" {
  type        = number
  description = "The minimum number of secondary worker instances"
  default     = 0
}

variable "preemptible_worker_max_instances" {
  type        = number
  description = "The maximum number of secondary worker instances"
  default     = 10
}

variable "worker_disk_type" {
  type        = string
  description = "The disk type of the primary disk attached to each worker node. One of 'pd-ssd' or 'pd-standard'."
  default     = "pd-standard"
}

variable "worker_disk_size" {
  type        = number
  description = "Size of the primary disk attached to each worker node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, it also contains the HDFS data blocks and Hadoop working directories."
  default     = 100
}

variable "worker_accelerator" {
  type = list(object({
    count = number
    type  = string
  }))
  description = "The number and type of the accelerator cards exposed to this instance. "
  default     = []
}

variable "worker_local_ssd" {
  type        = number
  description = "The amount of local SSD disks that will be attached to each worker cluster node."
  default     = 0
}

variable "labels" {
  type        = map(string)
  description = "Set of labels to identify the cluster"
  default     = {}
}

variable "scale_up_factor" {
  type        = number
  description = "Fraction of average pending memory in the last cooldown period for which to add workers. A scale-up factor of 1.0 will result in scaling up so that there is no pending memory remaining after the update (more aggressive scaling). A scale-up factor closer to 0 will result in a smaller magnitude of scaling up (less aggressive scaling). Bounds: [0.0, 1.0]."
  default     = 0.5
}

variable "scale_up_min_worker_fraction" {
  type        = number
  description = "Minimum scale-up threshold as a fraction of total cluster size before scaling occurs. For example, in a 20-worker cluster, a threshold of 0.1 means the autoscaler must recommend at least a 2-worker scale-up for the cluster to scale. A threshold of 0 means the autoscaler will scale up on any recommended change. Bounds: [0.0, 1.0]"
  default     = 0.0
}

variable "scale_down_factor" {
  type        = number
  description = "Fraction of average pending memory in the last cooldown period for which to remove workers. A scale-down factor of 1 will result in scaling down so that there is no available memory remaining after the update (more aggressive scaling). A scale-down factor of 0 disables removing workers, which can be beneficial for autoscaling a single job. Bounds: [0.0, 1.0]."
  default     = 1.0
}

variable "scale_down_min_worker_fraction" {
  type        = number
  description = "Minimum scale-down threshold as a fraction of total cluster size before scaling occurs. For example, in a 20-worker cluster, a threshold of 0.1 means the autoscaler must recommend at least a 2 worker scale-down for the cluster to scale. A threshold of 0 means the autoscaler will scale down on any recommended change. Bounds: [0.0, 1.0]."
  default     = 0.0
}

variable "cooldown_period" {
  type        = string
  description = "Duration between scaling events. A scaling period starts after the update operation from the previous event has completed. Bounds: [2m, 1d]."
  default     = "120s"
}

variable "graceful_decommission_timeout" {
  type        = string
  description = "Timeout for YARN graceful decommissioning of Node Managers. Specifies the duration to wait for jobs to complete before forcefully removing workers (and potentially interrupting jobs). Only applicable to downscaling operations. Bounds: [0s, 1d]."
  default     = "300s"
}

variable "internal_ip_only" {
  type        = string
  description = "Timeout for YARN graceful decommissioning of Node Managers. Specifies the duration to wait for jobs to complete before forcefully removing workers (and potentially interrupting jobs). Only applicable to downscaling operations. Bounds: [0s, 1d]."
  default     = "true"
}

variable "conda_packages" {
  type        = string
  description = "A space separated list of conda packages to be installed"
  default     = ""
}

variable "pip_packages" {
  type        = string
  description = "A space separated list of pip packages to be installed"
  default     = ""
}

variable "conda_initialization_script" {
  type        = string
  description = "Location of script in GS used to install conda packages (https://github.com/GoogleCloudPlatform/dataproc-initialization-actions)"
  default     = "gs://dataproc-initialization-actions/python/conda-install.sh"
}

variable "pip_initialization_script" {
  type        = string
  description = "Location of script in GS used to install pip packages (https://github.com/GoogleCloudPlatform/dataproc-initialization-actions)"
  default     = "gs://dataproc-initialization-actions/python/pip-install.sh"
}

variable "initialization_script" {
  type        = list(string)
  description = "List of additional initialization scripts"
  default     = []
}

variable "tags" {
  type        = list(string)
  description = "Tags used to enable network firewall rules"
  default     = []
}

variable "initialization_timeout_sec" {
  type        = number
  description = "The maximum duration (in seconds) which script is allowed to take to execute its action."
  default     = 300
}

variable "http_port_access" {
  type        = bool
  description = "Dataproc Gateway needed for Spark runs"
  default     = true
}

variable "kms_key_name" {
  type        = list(string)
  description = "KMS keys used for Dataproc encription"
  default     = []
}
