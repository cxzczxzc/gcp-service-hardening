# Dataproc Cluster Terraform module

Creates a Dataproc Cluster based on a Managed Instance Group.

It is expected for the cluster to use a subnet from the host networking Shared VPC project, so in order to provision the Dataproc cluster you should configure previously the expected Service Account, Service Agent, Firewall rules, IAM roles and APIs as documented in the [Shared VPC configuration](#shared-vpc-cluster-configuration) section.

## Quick Start

Run an only-plan test:
```
make test
```

Run a plan-apply-destroy test:
```
make test-apply
```

## Module Documentation

### Dataproc cluster configuration

#### Images

- If you want to run on different default images please review the supported [Image version list]( https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-versions) .

- We strongly recommend reviewing [this](https://github.com/GoogleCloudDataproc/custom-images) repository if you want to run on custom images.

- In case of needing having another packages not included in images, you can run initialization scripts (full path to .sh file as a variable)

#### Scopes

- To avoid recreation of the cluster in a new apply, the module includes a set of a minimum of required scopes for the cluster VMs:
    - `https://www.googleapis.com/auth/cloud.useraccounts.readonly`
    - `https://www.googleapis.com/auth/devstorage.read_write`
    - `https://www.googleapis.com/auth/logging.write`

#### Others
- You can reduce your cost using secondary workers as explained [here](https://cloud.google.com/dataproc/docs/concepts/compute/secondary-vms). Check `preemptible_worker_max_instances` and `preemptible_worker_min_instances` at `variables.tf` file.

- For High Availability Dataproc Cluster, please set variable `master_ha` to `True`. You can see more [here](https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/high-availability)

- If you need to enable Dataproc Gateway, please set to `True` variable `http_port_access`


### Shared VPC cluster configuration

#### Google beta provider

Google beta provider is required to be able to use the `enable_http_port_access` property.

#### Google API enablement requirements

##### Service project

The following APIs will be enabled when a new project is created using the `DevX Landing Zone's project vending`:

- Service Networking API: `servicenetworking.googleapis.com`
- Dataproc API: `dataproc.googleapis.com`
 
 
##### Host project

The following APIs should be enabled for the host networking project:

- IAM API: `iam.googleapis.com`
- Service Networking API: `servicenetworking.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
- Compute Engine API: `compute.googleapis.com`


#### IAM roles for the Service Account to be used by the cluster

It is required to assign the following [IAM roles](https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network#create_a_cluster_that_uses_a_network_in_another_project) to the Service Account that will be used by the VMs of the cluster to work with the Shared VPC network. Currently, these IAM roles are assigned on the `DevX Landing Zone's project vending`:

##### Service project

- Dataproc Editor: `roles/dataproc.editor`
- Dataproc Worker: `roles/dataproc.worker`
- Service Account User: `roles/iam.serviceAccountUser`

##### Host project (Shared VPC subnet)

- Compute Network User: `roles/compute.networkUser`



#### IAM roles for the Service Agent

These [IAM roles](https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network#create_a_cluster_that_uses_a_network_in_another_project) should be applied to the Google managed Service Agent that is created after the first cluster is created. This Service Agent should look like `service-[PROJECT-NUMBER]@dataproc-accounts.iam.gserviceaccount.com`. Currently, this Firewall rule is created by the `Shared VPC module in the DevX Landing Zone`:

##### Host project (Shared VPC subnet)

- Compute Network User: `roles/compute.networkUser`

##### Bucket level

- Storage Legacy Bucket Writer: `roles/storage.legacyBucketWriter`
- **Note**: this IAM role is only required if the bucket is not in the same project than the cluster. The IAM role should be
assigned to the Service Agent in the project where the bucket is located.



#### Firewall rule

##### Dataproc Ingress firewall rule (for the Shared VPC host project)

- To allow internal communication between masters and workers, an [ingress firewall rule](https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network#create_an_ingress_firewall_rule) will be automatically created in the Host Netowrking Project to allow traffic on the following protocols and ports:
    - TCP (all ports, 0 through 65535)
    - UDP (all ports, 0 through 65535)
    - ICMP 

- This rule uses the Service Account attached to the Dataproc cluster (source_service_accounts and target_service_accounts should be the same)

- Currently, this Firewall rule is automatically created in the [gcp_shared_vpc](https://github.com/dnb-main/terraform-google-dnb_gcp_shared_vpc/blob/e0b1e128946fd4c98b180fd9c7245a5dfc6475ad/main.tf#L197)

- There are currently 2 pre-requisites in order to ensure the above firewall rule is successfully implemented.
    - Update the default value of the enable_dataproc_regex variable in variables.tf in the [gcp_dnb_project](https://github.com/dnb-main/terraform-google-dnb_gcp_project/blob/main/variables.tf) repository to include your project prefix.  This ensures the dataproc Service Account is created in your project & the necessary IAM roles are mapped to the Service Account accordingly.
    - Update the value of the enable_dataproc_regex variable in mainorg-nonprod.tfvars in [devx-gcp-lz](https://github.com/dnb-main/devx-gcp-lz/blob/main/terraform/host-networking/environments/mainorg-nonprod.tfvars) repository to include your project prefix.  This ensures the necessary subnetworking permissions are granted to your Service Account.


##### Private Google Access (PGA)

- An [egress Firewall rule](https://cloud.google.com/vpc-service-controls/docs/set-up-private-connectivity#configure-firewall) should be created for the cluster VMs to reach internal Dataproc API (part of [Private Google APIs](https://cloud.google.com/vpc/docs/configure-private-google-access-hybrid#requirements))
- It should be created in the Host Project to allow traffic on all protocols and ports.

- Currently, this Firewall rule is created by the Currently, this Firewall rule is created by the `Shared VPC module in the DevX Landing Zone`.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.18.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.18.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_dataproc_cluster.dp_cluster](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dataproc_cluster) | resource |
| [google_dataproc_autoscaling_policy.asp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataproc_autoscaling_policy) | resource |
| [google_compute_subnetwork.shared_vpc_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the DataProc cluster to be created | `string` | n/a | yes |
| <a name="input_conda_initialization_script"></a> [conda\_initialization\_script](#input\_conda\_initialization\_script) | Location of script in GS used to install conda packages (https://github.com/GoogleCloudPlatform/dataproc-initialization-actions) | `string` | `"gs://dataproc-initialization-actions/python/conda-install.sh"` | no |
| <a name="input_conda_packages"></a> [conda\_packages](#input\_conda\_packages) | A space separated list of conda packages to be installed | `string` | `""` | no |
| <a name="input_cooldown_period"></a> [cooldown\_period](#input\_cooldown\_period) | Duration between scaling events. A scaling period starts after the update operation from the previous event has completed. Bounds: [2m, 1d]. | `string` | `"120s"` | no |
| <a name="input_graceful_decommission_timeout"></a> [graceful\_decommission\_timeout](#input\_graceful\_decommission\_timeout) | Timeout for YARN graceful decommissioning of Node Managers. Specifies the duration to wait for jobs to complete before forcefully removing workers (and potentially interrupting jobs). Only applicable to downscaling operations. Bounds: [0s, 1d]. | `string` | `"300s"` | no |
| <a name="input_host_project_id"></a> [host\_project\_id](#input\_host\_project\_id) | Project where the Shared VPC is located | `string` | n/a | yes |
| <a name="input_http_port_access"></a> [http\_port\_access](#input\_http\_port\_access) | Dataproc Gateway needed for Spark runs | `bool` | `true` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The image version of DataProc to be used, review https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-versions and here https://github.com/GoogleCloudDataproc/custom-images | `string` | `"2.0.51-debian10"` | no |
| <a name="input_initialization_script"></a> [initialization\_script](#input\_initialization\_script) | List of additional initialization scripts | `list(string)` | `[]` | no |
| <a name="input_initialization_timeout_sec"></a> [initialization\_timeout\_sec](#input\_initialization\_timeout\_sec) | The maximum duration (in seconds) which script is allowed to take to execute its action. | `number` | `300` | no |
| <a name="input_internal_ip_only"></a> [internal\_ip\_only](#input\_internal\_ip\_only) | Timeout for YARN graceful decommissioning of Node Managers. Specifies the duration to wait for jobs to complete before forcefully removing workers (and potentially interrupting jobs). Only applicable to downscaling operations. Bounds: [0s, 1d]. | `string` | `"true"` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | KMS keys used for Dataproc encription | `list(string)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Set of labels to identify the cluster | `map(string)` | `{}` | no |
| <a name="input_master_disk_size"></a> [master\_disk\_size](#input\_master\_disk\_size) | Size of the primary disk attached to each master node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, it also contains the HDFS data blocks and Hadoop working directories. | `number` | `100` | no |
| <a name="input_master_disk_type"></a> [master\_disk\_type](#input\_master\_disk\_type) | The disk type of the primary disk attached to each master node. One of 'pd-ssd' or 'pd-standard'. | `string` | `"pd-standard"` | no |
| <a name="input_master_ha"></a> [master\_ha](#input\_master\_ha) | Set to 'true' to enable 3 master nodes (HA) or 'false' for only 1 master node | `bool` | `false` | no |
| <a name="input_master_instance_type"></a> [master\_instance\_type](#input\_master\_instance\_type) | The instance type of the master node | `string` | `"n1-standard-4"` | no |
| <a name="input_master_local_ssd"></a> [master\_local\_ssd](#input\_master\_local\_ssd) | The amount of local SSD disks that will be attached to each master cluster node. | `number` | `0` | no |
| <a name="input_optional_components"></a> [optional\_components](#input\_optional\_components) | The optional softwares that need to be installed part of dataproc cluster provisioning. For example ZOOKEEPER,HIVE\_WEBHCAT,HBASE,SOLR] | `list(string)` | `[]` | no |
| <a name="input_override_properties"></a> [override\_properties](#input\_override\_properties) | The overrite properries that need to be set to dataproc cluster | `map(string)` | `{}` | no |
| <a name="input_pip_initialization_script"></a> [pip\_initialization\_script](#input\_pip\_initialization\_script) | Location of script in GS used to install pip packages (https://github.com/GoogleCloudPlatform/dataproc-initialization-actions) | `string` | `"gs://dataproc-initialization-actions/python/pip-install.sh"` | no |
| <a name="input_pip_packages"></a> [pip\_packages](#input\_pip\_packages) | A space separated list of pip packages to be installed | `string` | `""` | no |
| <a name="input_preemptible_worker_instance_type"></a> [preemptible\_worker\_instance\_type](#input\_preemptible\_worker\_instance\_type) | The instance type of the secondary worker nodes | `string` | `"n1-standard-4"` | no |
| <a name="input_preemptible_worker_max_instances"></a> [preemptible\_worker\_max\_instances](#input\_preemptible\_worker\_max\_instances) | The maximum number of secondary worker instances | `number` | `10` | no |
| <a name="input_preemptible_worker_min_instances"></a> [preemptible\_worker\_min\_instances](#input\_preemptible\_worker\_min\_instances) | The minimum number of secondary worker instances | `number` | `0` | no |
| <a name="input_primary_worker_max_instances"></a> [primary\_worker\_max\_instances](#input\_primary\_worker\_max\_instances) | The maximum number of primary worker instances | `number` | `10` | no |
| <a name="input_primary_worker_min_instances"></a> [primary\_worker\_min\_instances](#input\_primary\_worker\_min\_instances) | The minimum number of primary worker instances | `number` | `2` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project where the Dataproc cluster will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region where the cluster will be located | `string` | n/a | yes |
| <a name="input_scale_down_factor"></a> [scale\_down\_factor](#input\_scale\_down\_factor) | Fraction of average pending memory in the last cooldown period for which to remove workers. A scale-down factor of 1 will result in scaling down so that there is no available memory remaining after the update (more aggressive scaling). A scale-down factor of 0 disables removing workers, which can be beneficial for autoscaling a single job. Bounds: [0.0, 1.0]. | `number` | `1` | no |
| <a name="input_scale_down_min_worker_fraction"></a> [scale\_down\_min\_worker\_fraction](#input\_scale\_down\_min\_worker\_fraction) | Minimum scale-down threshold as a fraction of total cluster size before scaling occurs. For example, in a 20-worker cluster, a threshold of 0.1 means the autoscaler must recommend at least a 2 worker scale-down for the cluster to scale. A threshold of 0 means the autoscaler will scale down on any recommended change. Bounds: [0.0, 1.0]. | `number` | `0` | no |
| <a name="input_scale_up_factor"></a> [scale\_up\_factor](#input\_scale\_up\_factor) | Fraction of average pending memory in the last cooldown period for which to add workers. A scale-up factor of 1.0 will result in scaling up so that there is no pending memory remaining after the update (more aggressive scaling). A scale-up factor closer to 0 will result in a smaller magnitude of scaling up (less aggressive scaling). Bounds: [0.0, 1.0]. | `number` | `0.5` | no |
| <a name="input_scale_up_min_worker_fraction"></a> [scale\_up\_min\_worker\_fraction](#input\_scale\_up\_min\_worker\_fraction) | Minimum scale-up threshold as a fraction of total cluster size before scaling occurs. For example, in a 20-worker cluster, a threshold of 0.1 means the autoscaler must recommend at least a 2-worker scale-up for the cluster to scale. A threshold of 0 means the autoscaler will scale up on any recommended change. Bounds: [0.0, 1.0] | `number` | `0` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The service account for the cluster | `string` | `""` | no |
| <a name="input_service_account_scopes"></a> [service\_account\_scopes](#input\_service\_account\_scopes) | The set of Google API scopes to be made available on all of the node VMs | `list(string)` | `[]` | no |
| <a name="input_staging_bucket"></a> [staging\_bucket](#input\_staging\_bucket) | The id of the bucket to be used for staging | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Name of the subnetwork that the GCE VMs will be using. Must be part of the Shared VPC on the host project | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags used to enable network firewall rules | `list(string)` | `[]` | no |
| <a name="input_worker_accelerator"></a> [worker\_accelerator](#input\_worker\_accelerator) | The number and type of the accelerator cards exposed to this instance. | <pre>list(object({<br>    count = number<br>    type  = string<br>  }))</pre> | `[]` | no |
| <a name="input_worker_disk_size"></a> [worker\_disk\_size](#input\_worker\_disk\_size) | Size of the primary disk attached to each worker node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, it also contains the HDFS data blocks and Hadoop working directories. | `number` | `100` | no |
| <a name="input_worker_disk_type"></a> [worker\_disk\_type](#input\_worker\_disk\_type) | The disk type of the primary disk attached to each worker node. One of 'pd-ssd' or 'pd-standard'. | `string` | `"pd-standard"` | no |
| <a name="input_worker_instance_type"></a> [worker\_instance\_type](#input\_worker\_instance\_type) | The instance type of the worker nodes | `string` | `"n1-standard-4"` | no |
| <a name="input_worker_local_ssd"></a> [worker\_local\_ssd](#input\_worker\_local\_ssd) | The amount of local SSD disks that will be attached to each worker cluster node. | `number` | `0` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | GCP zone where the cluster will be located | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_http_ports"></a> [cluster\_http\_ports](#output\_cluster\_http\_ports) | n/a |
| <a name="output_cluster_master_instance_names"></a> [cluster\_master\_instance\_names](#output\_cluster\_master\_instance\_names) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_preemptible_worker_instance_names"></a> [cluster\_preemptible\_worker\_instance\_names](#output\_cluster\_preemptible\_worker\_instance\_names) | n/a |
| <a name="output_cluster_worker_instance_names"></a> [cluster\_worker\_instance\_names](#output\_cluster\_worker\_instance\_names) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->