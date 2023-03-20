variable "region" {
  type        = string
  description = "The region we are deploying to"
  default     = "us-central1"
}

variable "project_id" {
  type        = string
  description = "The name of the gcp project."
}

variable "cluster_name" {
  type        = string
  description = "The name of the gcp project."
}

variable "zone" {
  description = "The name to use as a prefix for all the resources created"
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

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = null
}