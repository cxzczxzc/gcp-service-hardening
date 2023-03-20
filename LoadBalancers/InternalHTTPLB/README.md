# terraform-google-dnb_gcp_http_internal_lb
This module supports managing GCP Layer 7(http|https) Internal Load Balancers(ILBs). Layer 7 ILBs are proxy based LBs on GCP, and a decicated proxy-only subnet is required. Pre-requisites such as proxy-only subnet, routing firewall rules are covered by DnB's host networking setup. This module is a ready to use module to create internal layer7 load balancers.

## Some key usage notes
- This module deploys ILB in SSL|HTTPS mode by default, and [http-to-https redirect](https://cloud.google.com/load-balancing/docs/l7-internal/setting-up-http-to-https-redirect) is enabled by default.
- L7 Internal Load Balancers(ILBs) and associated resources are regional resources, so clients/apps within the region can access ILBs.
- [URL maps](https://cloud.google.com/load-balancing/docs/l7-internal#url_map)([TF resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map)) are what provides the ability to configure granular routing across backends. 
- Scope of L7 ILBs [accessibility](https://cloud.google.com/load-balancing/docs/l7-internal#accessing_connected_networks)
- [Limitations section](https://cloud.google.com/load-balancing/docs/l7-internal#limitations)

## Module usage

```
module "http_ilb" {
  source     = "app.terraform.io/dnb-core/dnb_gcp_http_internal_lb/google"
  version    = "x.x.x"
  name       = "internal-lb-http"
  project    = var.project_id
  network    = var.network
  region     = "us-east4"
  subnetwork = var.subnetwork

  backends = {
    default = {
      description = "Test MIG backend group"
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 30
      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        { group = google_compute_instance_group_manager.default.instance_group }
      ]

      iap_config = {
        enable = false
      }
    }
  }
  certificate = tls_self_signed_cert.cert.cert_pem  #var.certificate
  private_key = tls_private_key.key.private_key_pem # var.private_key
}
```

`certificate` and `private_key` are required, and these can be either [self-signed](https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs) or DnB's CA issued certs, which can be stored as secrets and retrived.  
Please refer to the example for additional usage details.

## References
- [Secret creation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version).
- [Reading secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version).

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
| [google-beta_google_compute_address.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_address) | resource |
| [google-beta_google_compute_region_backend_service.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_backend_service) | resource |
| [google-beta_google_compute_region_health_check.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_health_check) | resource |
| [google-beta_google_compute_region_ssl_policy.dnb-ssl-policy](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_ssl_policy) | resource |
| [google-beta_google_compute_region_target_https_proxy.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_target_https_proxy) | resource |
| [google_compute_forwarding_rule.http](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_forwarding_rule.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule) | resource |
| [google_compute_region_ssl_certificate.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_ssl_certificate) | resource |
| [google_compute_region_target_http_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy) | resource |
| [google_compute_region_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map) | resource |
| [google_compute_region_url_map.https_redirect](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map) | resource |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address"></a> [address](#input\_address) | Existing IPv4 address to use for ILB (the actual IP address value) | `string` | `null` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | Map backend indices to list of backend maps. | <pre>map(object({<br>    protocol                        = string<br>    port                            = number<br>    port_name                       = string<br>    description                     = optional(string)<br>    timeout_sec                     = number<br>    connection_draining_timeout_sec = optional(number)<br>    session_affinity                = optional(string)<br>    affinity_cookie_ttl_sec         = optional(number)<br><br>    health_check = object({<br>      check_interval_sec  = optional(number)<br>      timeout_sec         = optional(number)<br>      healthy_threshold   = optional(number)<br>      unhealthy_threshold = optional(number)<br>      request_path        = string<br>      port                = number<br>      host                = optional(string)<br>      logging             = optional(bool)<br>    })<br><br>    log_config = object({<br>      enable      = bool<br>      sample_rate = number<br>    })<br><br>    groups = list(object({<br>      group = string<br><br>      balancing_mode               = optional(string)<br>      capacity_scaler              = optional(number)<br>      description                  = optional(string)<br>      max_connections              = optional(number)<br>      max_connections_per_instance = optional(number)<br>      max_connections_per_endpoint = optional(number)<br>      max_rate                     = optional(number)<br>      max_rate_per_instance        = optional(number)<br>      max_rate_per_endpoint        = optional(number)<br>      max_utilization              = optional(number)<br>    }))<br>    iap_config = object({<br>      enable               = bool<br>      oauth2_client_id     = optional(string)<br>      oauth2_client_secret = optional(string)<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_certificate"></a> [certificate](#input\_certificate) | Content of the SSL certificate. Required if `ssl`\|`https_redirect` are `true` and `ssl_certificates` is empty. | `string` | `null` | no |
| <a name="input_create_address"></a> [create\_address](#input\_create\_address) | Create a new internal IPv4 address for ILB. | `bool` | `true` | no |
| <a name="input_create_url_map"></a> [create\_url\_map](#input\_create\_url\_map) | Set to `false` if url\_map variable is provided. | `bool` | `true` | no |
| <a name="input_http_forward"></a> [http\_forward](#input\_http\_forward) | Set to `true` to enable HTTP port 80 forward. Also set 'ssl' and 'https\_redirect' appropriately. | `bool` | `false` | no |
| <a name="input_https_redirect"></a> [https\_redirect](#input\_https\_redirect) | Set to `false` to disable https redirect on the ILB. | `bool` | `true` | no |
| <a name="input_ip_protocol"></a> [ip\_protocol](#input\_ip\_protocol) | The IP protocol for the backend and frontend forwarding rule. HTTP or HTTPS | `string` | `"HTTP"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to attach to resources created by this module | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the forwarding rule and prefix for supporting resources. | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Name of the network to create resources in. | `string` | n/a | yes |
| <a name="input_network_project"></a> [network\_project](#input\_network\_project) | Name of the project for the network. Useful for shared VPC. Default is var.project. | `string` | `""` | no |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Content of the private SSL key. Required if `ssl`\|`https_redirect` are `true` and `ssl_certificates` is empty. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | The project to deploy to, if not set the default provider project is used. | `string` | n/a | yes |
| <a name="input_quic"></a> [quic](#input\_quic) | Set to `true` to enable QUIC support | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | ILB region. | `string` | `"us-east4"` | no |
| <a name="input_ssl"></a> [ssl](#input\_ssl) | Set to `false` to disable SSL support. | `bool` | `true` | no |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | SSL cert self\_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided. | `list(string)` | `[]` | no |
| <a name="input_ssl_custom_features"></a> [ssl\_custom\_features](#input\_ssl\_custom\_features) | List of custom ciphers. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy | `list(string)` | `[]` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Selfink to SSL Policy to override DnB's default policy. | `string` | `null` | no |
| <a name="input_ssl_profile"></a> [ssl\_profile](#input\_ssl\_profile) | SSL Profile. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy | `string` | `"MODERN"` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Name of the subnetwork to create resources in. | `string` | n/a | yes |
| <a name="input_url_map"></a> [url\_map](#input\_url\_map) | The url\_map resource to use. Default is to send all traffic to first backend. | `string` | `null` | no |
| <a name="input_use_ssl_certificates"></a> [use\_ssl\_certificates](#input\_use\_ssl\_certificates) | If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate` | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_services"></a> [backend\_services](#output\_backend\_services) | The backend service resources. |
| <a name="output_http_proxy"></a> [http\_proxy](#output\_http\_proxy) | The HTTP proxy used by this module. |
| <a name="output_https_proxy"></a> [https\_proxy](#output\_https\_proxy) | The HTTPS proxy used by this module. |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IP address assigned to ILB's fowarding rule. |
| <a name="output_url_map"></a> [url\_map](#output\_url\_map) | The default URL map used by this module. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
