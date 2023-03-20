# Workload Identity in GKE

Workload Identity enables GKE workloads (pods, deployments, etc.) to interact with GCP resources as a GCP service account. 
When enabled, the k8s workload can perform all actions the GCP service account is enabled to use via IAM bindings. 


An example usage can be found in main.tf. For more information on how to utilize workload identity, navigate to the GCP documentation

## Requirements

1. Workload identity is enabled by default when using this module via the `identity_namespace` module variable is set to "enabled" by default
    1. This creates a workload identity pool for the cluster to use in the format of `var.<project_id>.svc.id.goog`
2. enable `GKE_METADATA as the node_identiy var`
    * This is a required step in the enablement process referenced in the [GCP docs](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#option_1_node_pool_creation_with_recommended)
    * For more information head to this [GCP concepts doc](https://cloud.google.com/kubernetes-engine/docs/concepts/workload-identity#metadata_server)
        * TL;DR - GKE metadata server is used to intercept requests to GCP and request the token needed to complete a request with Workload Identity. The flag then enables pods to utilize GKE metadata server instead of GCE metadata server (the metadata server typically used on a VM host)

## Upgrading from 3.4.0 or earlier

To make use of workload identity and ensure `node_metadata = "GKE_METADATA"` is applied to your nodepools, 
the cluster (or just the affected nodepools) will have to be re-applied. The easiest way to accomplish this
is by running a `terraform destroy` job followed by a `terraform apply`.

If you do not want to make use of workload identity in your cluster, upgrading to 3.5.x will not cause the 
cluster to redeploy automatically.