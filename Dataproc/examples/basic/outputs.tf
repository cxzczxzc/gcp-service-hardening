output "cluster_name" {
  value = module.dp_cluster.cluster_name
}

output "cluster_master_instance_names" {
  value = module.dp_cluster.cluster_master_instance_names
}

output "cluster_worker_instance_names" {
  value = module.dp_cluster.cluster_worker_instance_names
}

output "cluster_preemptible_worker_instance_names" {
  value = module.dp_cluster.cluster_preemptible_worker_instance_names
}

output "cluster_http_ports" {
  value = module.dp_cluster.cluster_http_ports
}