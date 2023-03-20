# terraform-google-dnb_gcp_tcp_udp_internal_lb
This module supports managing GCP [TCP/UDP](https://cloud.google.com/load-balancing/docs/internal) Internal Load Balancers.

## Some key usage notes
- TCP/UDP Internal Load Balancers(ILBs) and associated resources are regional resources, so clients/apps within the region can access ILBs.
- TCP/UDP ILBs support [global_access](https://cloud.google.com/load-balancing/docs/internal#forwarding_rules_and_global_access) for cross regional access. Module deploys these ILBs in regional(non global-access) mode by default.

## Usage

```hcl
module "tcp_ilb" {
  source      = "app.terraform.io/dnb-core/dnb_gcp_tcp_udp_internal_lb/google"
  version     = "x.x.x"
  project     = var.project_id
  network     = local.test_network
  subnetwork  = local.test_subnet
  region      = var.region
  name        = "internal-lb-tcp"
  ip_protocol = "TCP"
  ports       = ["80"]
  backends = [
    { group = google_compute_instance_group_manager.default.instance_group, description = "MIG backend primary", failover = false },
    { group = google_compute_instance_group_manager.mig02.instance_group, description = "MIG backend 02", failover = false },
  ]
  health_check = {
    request_path = "/"
    port         = 80
    enable_log   = true
    type         = "http"
  }
}

```

### References
- [TCP/UDP](https://cloud.google.com/load-balancing/docs/internal) ILBs overview.
- [Shared VPC Architecture for ILBs](https://cloud.google.com/load-balancing/docs/internal#shared-vpc).
- [Monitoring capabilities](https://cloud.google.com/load-balancing/docs/internal/internal-logging-monitoring)

## Quick Start

Instructions for configuring TFC Workspace to leverage terratest github actions with your repo.  This template has all necessary configuration files to leverage terratest via github actions.  You will need to set up a corresponding TFC workspace with your repo to ensure your github action functions properly.  The steps below are the manual workaround until https://jira.aws.dnb.com/browse/DEEP-541 is completed.

   * Create a GCP Project via DevX Portal (https://devx-portal.inf.dnb.net/) if you do not have one already.
   * Create a TFC Workspace via DevX Portal (https://devx-portal.inf.dnb.net/) if you do not have one already.  TFC Workspace will need to be tied to previously mentioned GCP Project.
   * When TFC Workspace is available, navigate in your Workspace to Settings --> Team Access & select Add Teams and Permissions, click on Show all available teams at bottom of the page and Select terratest team & assign write permissions
   * When TFC Workspace is available, navigate in your Workspace to Settings --> Version Control & select Change source.  Choose API-driven workflow.

Your workspace is now configured to be leveraged by GitHub for terratest.

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

### Required Providers

The template repo contains a few required providers for the module repo, which specify module version ranges in the `./versions.tf` file. Versions will be updated and maintained by Dependabot. If unneeded for the given module, remove from the `./versions.tf` file in order to prevent unnecessary provider downloads during `terraform init`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_forwarding_rule.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_health_check.http](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_health_check.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_health_check.tcp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_region_backend_service.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_all_ports"></a> [all\_ports](#input\_all\_ports) | Boolean for all\_ports setting on forwarding rule. | `bool` | `null` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | List of backends, should be a map of key-value pairs for each backend, must have the 'group' key. | `list(any)` | n/a | yes |
| <a name="input_connection_draining_timeout_sec"></a> [connection\_draining\_timeout\_sec](#input\_connection\_draining\_timeout\_sec) | Time for which instance will be drained | `number` | `null` | no |
| <a name="input_global_access"></a> [global\_access](#input\_global\_access) | Allow all regions on the same VPC network access. | `bool` | `false` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health check to determine whether instances are responsive and able to do work | <pre>object({<br>    name                = optional(string)<br>    type                = string<br>    check_interval_sec  = optional(number)<br>    healthy_threshold   = optional(number)<br>    timeout_sec         = optional(number)<br>    unhealthy_threshold = optional(number)<br>    response            = optional(string)<br>    proxy_header        = optional(string)<br>    port                = optional(number)<br>    port_name           = optional(string)<br>    request             = optional(string)<br>    request_path        = optional(string)<br>    host                = optional(string)<br>    enable_log          = optional(bool)<br>  })</pre> | n/a | yes |
| <a name="input_ip_address"></a> [ip\_address](#input\_ip\_address) | IP address of the internal load balancer, if empty one will be assigned. Default is empty. | `any` | `null` | no |
| <a name="input_ip_protocol"></a> [ip\_protocol](#input\_ip\_protocol) | The IP protocol for the backend and frontend forwarding rule. TCP or UDP. | `string` | `"TCP"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to attach to resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_load_balancing_scheme"></a> [load\_balancing\_scheme](#input\_load\_balancing\_scheme) | value | `string` | `"INTERNAL"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the forwarding rule and prefix for supporting resources. | `any` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Name of the network to create resources in. | `string` | n/a | yes |
| <a name="input_network_project"></a> [network\_project](#input\_network\_project) | Name of the project for the network. Useful for shared VPC. Default is var.project. | `string` | `""` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | List of ports range to forward to backend services. Max is 5. | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project to deploy to, if not set the default provider project is used. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for cloud resources. | `string` | `"us-east4"` | no |
| <a name="input_service_label"></a> [service\_label](#input\_service\_label) | Service label is used to create internal DNS name | `string` | `null` | no |
| <a name="input_session_affinity"></a> [session\_affinity](#input\_session\_affinity) | The session affinity for the backends example: NONE, CLIENT\_IP. Default is `NONE`. | `string` | `"NONE"` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Name of the subnetwork to create resources in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_forwarding_rule"></a> [forwarding\_rule](#output\_forwarding\_rule) | The forwarding rule self\_link. |
| <a name="output_forwarding_rule_id"></a> [forwarding\_rule\_id](#output\_forwarding\_rule\_id) | The forwarding rule id. |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The internal IP assigned to the regional forwarding rule. |
| <a name="output_name"></a> [name](#output\_name) | ILB name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
