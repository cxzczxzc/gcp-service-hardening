# Terraform Google Dataproc Jira ticket #####

This terraform code shows a simple example of how to deploy dataproc Cluster.
It also includes a full Dataproc module with different configurations on the cluster, master and worker nodes.

## Prerequesites

Two firewall rules and a service account are included in this example. 
Network and Subnetwork Ranges has to be provided on target project.
Please specify your IP ranges to open specific ports: https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network.
Please enable Private Connection on the subrange where this cluster will be deployed (given internal_ip_only configuration is defined).

## Autoscaling Policy
Also review autoscaling policy desired to the architectured workload

```hcl
resource "google_dataproc_autoscaling_policy" "asp" {
  provider = "google-beta"
  project = var.project_id
  policy_id = "${var.cluster_name}-policy"
  location = var.region


  worker_config {
    min_instances = var.primary_worker_min_instances
    max_instances = var.primary_worker_max_instances
    weight = 1
  }

  secondary_worker_config {
    min_instances = var.preemptible_worker_min_instances
    max_instances = var.preemptible_worker_max_instances
    weight = 3
  }

  basic_algorithm {
    cooldown_period = var.cooldown_period
    yarn_config {
      graceful_decommission_timeout = var.graceful_decommission_timeout

      scale_up_factor   = var.scale_up_factor
      scale_up_min_worker_fraction = var.scale_up_min_worker_fraction
      scale_down_factor = var.scale_down_factor
      scale_down_min_worker_fraction = var.scale_down_min_worker_fraction
    }
  }
}
```


