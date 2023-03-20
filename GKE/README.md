# terraform-module-repo-template
A terraform module to create a private GKE cluster with certain defaults to standardize on our GKE approach at DNB.
Creates regional private GKE cluster with configurable node-pool. 

### Internal Load Balancer Ingress
 This module comes with a flag, `enable_http_lb` that allows usage of Internal HTTP Load Balancing via GKE ingress. 
 When enabled, some annotations on Ingress and Service resources will connect a load balancer to a specified service in the cluster and allow communication within the VPC. For an example of the necessary resources, check out the [examples/basic/k8s-ingress.md file](examples/basic/k8s-ingress.md)

## Quick Start

Test module locally: 
```
make test
```

Apply configuration to currently configured/authenticated AWS ENV:
```
make test-apply
```

## Module Documentation
[Terraform docs](https://github.com/terraform-docs/terraform-docs) is used to ensure proper module documentation.

## Contributing


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_infoblox"></a> [infoblox](#requirement\_infoblox) | 2.0.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_infoblox"></a> [infoblox](#provider\_infoblox) | 2.0.1 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dnb_gcp_shared_constants"></a> [dnb\_gcp\_shared\_constants](#module\_dnb\_gcp\_shared\_constants) | app.terraform.io/dnb-core/dnb_gcp_shared_constants/google | 1.8.0 |
| <a name="module_helm_vault"></a> [helm\_vault](#module\_helm\_vault) | app.terraform.io/dnb-core/dnb_vault_agent_helm_release/google | 1.0.1 |
| <a name="module_kubernetes-engine"></a> [kubernetes-engine](#module\_kubernetes-engine) | terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster-update-variant | 25.0.0 |

## Resources

| Name | Type |
|------|------|
| [infoblox_ipv4_network.gke_control_plane_cidr](https://registry.terraform.io/providers/infobloxopen/infoblox/2.0.1/docs/resources/ipv4_network) | resource |
| [null_resource.register_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_integer.cluster_tier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_plan_cron_schedule"></a> [backup\_plan\_cron\_schedule](#input\_backup\_plan\_cron\_schedule) | Schedule on which backups will be automatically created. Use standard cron syntax. | `string` | `"0 * * * *"` | no |
| <a name="input_backup_plan_name"></a> [backup\_plan\_name](#input\_backup\_plan\_name) | Name of the default backup plan | `string` | `"backup-plan"` | no |
| <a name="input_backup_retain_days"></a> [backup\_retain\_days](#input\_backup\_retain\_days) | Retention days for the default backup plan | `string` | `"1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | n/a | yes |
| <a name="input_config_connector"></a> [config\_connector](#input\_config\_connector) | (Beta) Whether ConfigConnector is enabled for this cluster. | `bool` | `true` | no |
| <a name="input_default_max_pods_per_node"></a> [default\_max\_pods\_per\_node](#input\_default\_max\_pods\_per\_node) | count of pods (and ips) to provision per node | `number` | `32` | no |
| <a name="input_default_protected_application"></a> [default\_protected\_application](#input\_default\_protected\_application) | Default protected application argument for generic backup and restore plans. | `string` | `"dev/sample"` | no |
| <a name="input_enable_filestore_csi_driver"></a> [enable\_filestore\_csi\_driver](#input\_enable\_filestore\_csi\_driver) | Enables filestore csi driver add on | `bool` | `false` | no |
| <a name="input_enable_http_lb"></a> [enable\_http\_lb](#input\_enable\_http\_lb) | Enables http load balancer add on (required for ingress) | `bool` | `false` | no |
| <a name="input_enable_intranode_visibility"></a> [enable\_intranode\_visibility](#input\_enable\_intranode\_visibility) | Whether the Intranode Visibility is enabled for this cluster. | `bool` | `true` | no |
| <a name="input_enable_managed_prometheus"></a> [enable\_managed\_prometheus](#input\_enable\_managed\_prometheus) | (beta) whether or not the managed collection for Prometheus is enabled. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment stage | `string` | `"non_prod"` | no |
| <a name="input_gateway_api_channel"></a> [gateway\_api\_channel](#input\_gateway\_api\_channel) | The gateway api channel of this cluster. Accepted values are `CHANNEL_STANDARD` and `CHANNEL_DISABLED`. | `string` | `"CHANNEL_DISABLED"` | no |
| <a name="input_gke_backup_agent_config"></a> [gke\_backup\_agent\_config](#input\_gke\_backup\_agent\_config) | (Beta) Whether Backup for GKE agent is enabled for this cluster. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | `string` | `"latest"` | no |
| <a name="input_monitoring_enabled_components"></a> [monitoring\_enabled\_components](#input\_monitoring\_enabled\_components) | List of services to monitor: SYSTEM\_COMPONENTS, WORKLOADS (provider version >= 3.89.0). Empty list is default GKE configuration. | `list(string)` | `[]` | no |
| <a name="input_namespaced_resource_restore_mode"></a> [namespaced\_resource\_restore\_mode](#input\_namespaced\_resource\_restore\_mode) | Define how to handle restore-time conflicts for namespaced resources. | `string` | `"delete-and-restore"` | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network created to host the cluster in | `any` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of maps containing node pools | `list(map(string))` | <pre>[<br>  {<br>    "name": "default-node-pool",<br>    "tags": ""<br>  }<br>]</pre> | no |
| <a name="input_node_pools_labels"></a> [node\_pools\_labels](#input\_node\_pools\_labels) | map of node pool to map of labels | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {<br>    "default-node-pool": true<br>  }<br>}</pre> | no |
| <a name="input_node_pools_metadata"></a> [node\_pools\_metadata](#input\_node\_pools\_metadata) | map of node pool to map of node pool metadata | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {<br>    "default-node-pool": true<br>  }<br>}</pre> | no |
| <a name="input_node_pools_taints"></a> [node\_pools\_taints](#input\_node\_pools\_taints) | Map of lists of objects describing taints for nodepool, indexed by nodepool name | `map(list(object({ key = string, value = string, effect = string })))` | <pre>{<br>  "all": [],<br>  "default-node-pool": [<br>    {<br>      "effect": "PREFER_NO_SCHEDULE",<br>      "key": "default-node-pool",<br>      "value": true<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID of the gcp project. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region | `any` | n/a | yes |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The release channel of this cluster. Accepted values are `REGULAR`(recommended for nonprod)  and `STABLE`(recommended for prod). Defaults to `STABLE`. | `string` | `"STABLE"` | no |
| <a name="input_restore_plan_name"></a> [restore\_plan\_name](#input\_restore\_plan\_name) | Name of the default restore plan | `string` | `"restore-plan"` | no |
| <a name="input_secondary_subnet_pods"></a> [secondary\_subnet\_pods](#input\_secondary\_subnet\_pods) | The secondary ip range to use for pods | `any` | n/a | yes |
| <a name="input_secondary_subnet_services"></a> [secondary\_subnet\_services](#input\_secondary\_subnet\_services) | The secondary ip range to use for services | `any` | n/a | yes |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The service account to run nodes as if not overridden in `node_pools`. The create\_service\_account variable default value (true) will cause a cluster-specific service account to be created. | `string` | `""` | no |
| <a name="input_skip_fleet_registration"></a> [skip\_fleet\_registration](#input\_skip\_fleet\_registration) | Skip Anthos Fleet registration. Make sure you have an approval. | `bool` | `false` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | The subnetwork created to host the cluster in | `any` | n/a | yes |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Name of vault installation using helm | `string` | `"vault"` | no |
| <a name="input_vault_namespace"></a> [vault\_namespace](#input\_vault\_namespace) | Namespace where vault agent will be installed using helm | `string` | `"dnb-system"` | no |
| <a name="input_vault_server_address"></a> [vault\_server\_address](#input\_vault\_server\_address) | Address to Vault Server | `string` | `"https://dnb-prd-private-vault-cb7dcf70.f95a28af.z1.hashicorp.cloud:8200"` | no |
| <a name="input_volume_data_restore_policy"></a> [volume\_data\_restore\_policy](#input\_volume\_data\_restore\_policy) | Define how data is populated for restored volumes. If this flag is not specified, 'no-volume-data-restoration' will be used. | `string` | `"restore-volume-data-from-backup"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | Cluster ca certificate (base64 encoded) |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Cluster ID |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cluster endpoint |
| <a name="output_horizontal_pod_autoscaling_enabled"></a> [horizontal\_pod\_autoscaling\_enabled](#output\_horizontal\_pod\_autoscaling\_enabled) | Whether horizontal pod autoscaling enabled |
| <a name="output_http_load_balancing_enabled"></a> [http\_load\_balancing\_enabled](#output\_http\_load\_balancing\_enabled) | Whether http load balancing enabled |
| <a name="output_identity_namespace"></a> [identity\_namespace](#output\_identity\_namespace) | Workload Identity pool |
| <a name="output_instance_group_urls"></a> [instance\_group\_urls](#output\_instance\_group\_urls) | List of GKE generated instance groups |
| <a name="output_location"></a> [location](#output\_location) | Cluster location (region if regional cluster, zone if zonal cluster) |
| <a name="output_logging_service"></a> [logging\_service](#output\_logging\_service) | Logging service used |
| <a name="output_master_authorized_networks_config"></a> [master\_authorized\_networks\_config](#output\_master\_authorized\_networks\_config) | Networks from which access to master is permitted |
| <a name="output_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#output\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation used for the hosted master network |
| <a name="output_master_version"></a> [master\_version](#output\_master\_version) | Current master kubernetes version |
| <a name="output_min_master_version"></a> [min\_master\_version](#output\_min\_master\_version) | Minimum master kubernetes version |
| <a name="output_monitoring_service"></a> [monitoring\_service](#output\_monitoring\_service) | Monitoring service used |
| <a name="output_name"></a> [name](#output\_name) | Cluster name |
| <a name="output_network_policy_enabled"></a> [network\_policy\_enabled](#output\_network\_policy\_enabled) | Whether network policy enabled |
| <a name="output_node_pools_names"></a> [node\_pools\_names](#output\_node\_pools\_names) | List of node pools names |
| <a name="output_node_pools_versions"></a> [node\_pools\_versions](#output\_node\_pools\_versions) | Node pool versions by node pool name |
| <a name="output_peering_name"></a> [peering\_name](#output\_peering\_name) | The name of the peering between this cluster and the Google owned VPC. |
| <a name="output_region"></a> [region](#output\_region) | Cluster region |
| <a name="output_release_channel"></a> [release\_channel](#output\_release\_channel) | The release channel of this cluster |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | The service account to default running nodes as if not overridden in `node_pools`. |
| <a name="output_type"></a> [type](#output\_type) | Cluster type (regional / zonal) |
| <a name="output_zones"></a> [zones](#output\_zones) | List of zones in which the cluster resides |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
