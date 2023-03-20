variable "project_id" {
  type        = string
  description = "ID of the gcp project."
}

variable "region" {
  description = "region"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "network" {
  description = "The VPC network created to host the cluster in"
}

variable "subnet" {
  description = "The subnetwork created to host the cluster in"
}

variable "secondary_subnet_pods" {
  description = "The secondary ip range to use for pods"
}

variable "secondary_subnet_services" {
  description = "The secondary ip range to use for services"
}

variable "service_account" {
  type        = string
  description = "The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created."
  default     = ""
}

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
      tags = ""

    },
  ]
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "map of node pool to map of labels"

  default = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }
}

variable "node_pools_metadata" {
  type        = map(map(string))
  description = "map of node pool to map of node pool metadata"

  default = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }
}

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists of objects describing taints for nodepool, indexed by nodepool name"

  default = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }
}

variable "default_max_pods_per_node" {
  type        = number
  description = "count of pods (and ips) to provision per node"
  default     = 32
  // see: https://cloud.google.com/kubernetes-engine/docs/best-practices/networking#pod-density-per-node
  // and: https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `REGULAR`(recommended for nonprod)  and `STABLE`(recommended for prod). Defaults to `STABLE`."
  default     = "STABLE"
  validation {
    condition     = contains(["REGULAR", "STABLE"], var.release_channel)
    error_message = "Accepted values are `REGULAR`(recommended for nonprod)  and `STABLE`(recommended for prod)."
  }
}

variable "environment" {
  type        = string
  description = "Application environment stage"
  default     = "non_prod"
  validation {
    condition     = contains(["non_prod", "prod"], var.environment)
    error_message = "Valid values for var: environment are (non_prod, prod)."
  }
}

variable "enable_http_lb" {
  type        = bool
  default     = false
  description = "Enables http load balancer add on (required for ingress)"
}

variable "enable_filestore_csi_driver" {
  type        = bool
  default     = false
  description = "Enables filestore csi driver add on"
}

variable "config_connector" {
  type        = bool
  description = "(Beta) Whether ConfigConnector is enabled for this cluster."
  default     = true
}

variable "skip_fleet_registration" {
  type        = bool
  description = "Skip Anthos Fleet registration. Make sure you have an approval."
  default     = false
}

variable "enable_intranode_visibility" {
  type        = bool
  description = "Whether the Intranode Visibility is enabled for this cluster."
  default     = true
}

variable "gke_backup_agent_config" {
  type        = bool
  description = "(Beta) Whether Backup for GKE agent is enabled for this cluster."
  default     = true
}

variable "backup_plan_cron_schedule" {
  type        = string
  description = "Schedule on which backups will be automatically created. Use standard cron syntax."
  default     = "0 * * * *"
}

variable "backup_plan_name" {
  type        = string
  description = "Name of the default backup plan"
  default     = "backup-plan"
}

variable "backup_retain_days" {
  type        = string
  description = "Retention days for the default backup plan"
  default     = "1"
}

variable "restore_plan_name" {
  type        = string
  description = "Name of the default restore plan"
  default     = "restore-plan"
}

variable "volume_data_restore_policy" {
  type        = string
  description = "Define how data is populated for restored volumes. If this flag is not specified, 'no-volume-data-restoration' will be used."
  default     = "restore-volume-data-from-backup"
}

variable "namespaced_resource_restore_mode" {
  type        = string
  description = "Define how to handle restore-time conflicts for namespaced resources."
  default     = "delete-and-restore"
}

variable "default_protected_application" {
  type        = string
  description = "Default protected application argument for generic backup and restore plans."
  default     = "dev/sample"
}

variable "vault_server_address" {
  type        = string
  description = "Address to Vault Server"
  default     = "https://dnb-prd-private-vault-cb7dcf70.f95a28af.z1.hashicorp.cloud:8200"
}

variable "vault_name" {
  type        = string
  description = "Name of vault installation using helm"
  default     = "vault"
}

variable "vault_namespace" {
  type        = string
  description = "Namespace where vault agent will be installed using helm"
  default     = "dnb-system"
}

variable "enable_managed_prometheus" {
  type        = bool
  description = "(beta) whether or not the managed collection for Prometheus is enabled."
  default     = false
}

variable "gateway_api_channel" {
  type        = string
  description = "The gateway api channel of this cluster. Accepted values are `CHANNEL_STANDARD` and `CHANNEL_DISABLED`."
  default     = "CHANNEL_DISABLED"
}

variable "monitoring_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, WORKLOADS (provider version >= 3.89.0). Empty list is default GKE configuration."
  default     = []
}