output "cluster_name" {
  value = google_dataproc_cluster.dp_cluster.name
}

output "cluster_master_instance_names" {
  value = google_dataproc_cluster.dp_cluster.cluster_config.0.master_config.0.instance_names
}

output "cluster_worker_instance_names" {
  value = google_dataproc_cluster.dp_cluster.cluster_config.0.worker_config.0.instance_names
}

output "cluster_preemptible_worker_instance_names" {
  value = google_dataproc_cluster.dp_cluster.cluster_config.0.preemptible_worker_config.0.instance_names
}

output "cluster_http_ports" {
  value = google_dataproc_cluster.dp_cluster.cluster_config.0.endpoint_config.0.http_ports
}