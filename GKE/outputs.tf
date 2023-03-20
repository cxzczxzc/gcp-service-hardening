output "cluster_id" {
  description = "Cluster ID"
  value       = module.kubernetes-engine.cluster_id
}

output "name" {
  description = "Cluster name"
  value       = module.kubernetes-engine.name
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = module.kubernetes-engine.type
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.kubernetes-engine.location
}

output "region" {
  description = "Cluster region"
  value       = module.kubernetes-engine.region
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.kubernetes-engine.zones
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.kubernetes-engine.endpoint
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = module.kubernetes-engine.min_master_version
}

output "logging_service" {
  description = "Logging service used"
  value       = module.kubernetes-engine.logging_service
}

output "monitoring_service" {
  description = "Monitoring service used"
  value       = module.kubernetes-engine.monitoring_service
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.kubernetes-engine.master_authorized_networks_config
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.kubernetes-engine.master_version
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.kubernetes-engine.ca_certificate
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = module.kubernetes-engine.network_policy_enabled
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = module.kubernetes-engine.http_load_balancing_enabled
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = module.kubernetes-engine.horizontal_pod_autoscaling_enabled
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = module.kubernetes-engine.node_pools_names
}

output "node_pools_versions" {
  description = "Node pool versions by node pool name"
  value       = module.kubernetes-engine.node_pools_versions
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.kubernetes-engine.service_account
}

output "instance_group_urls" {
  description = "List of GKE generated instance groups"
  value       = module.kubernetes-engine.instance_group_urls
}

output "release_channel" {
  description = "The release channel of this cluster"
  value       = module.kubernetes-engine.release_channel
}

output "identity_namespace" {
  description = "Workload Identity pool"
  value       = module.kubernetes-engine.identity_namespace
}

output "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation used for the hosted master network"
  value       = module.kubernetes-engine.master_ipv4_cidr_block
}

output "peering_name" {
  description = "The name of the peering between this cluster and the Google owned VPC."
  value       = module.kubernetes-engine.peering_name
}
