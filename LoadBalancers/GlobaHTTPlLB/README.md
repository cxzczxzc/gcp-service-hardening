# terraform-google-dnb_gcp_http_global_lb
This module supports managing GCP Layer 7(http|https) Global/Public Load Balancer(GLB). Layer 7 load balancers are proxy based on GCP, and a decicated proxy-only subnet is required. This module is a ready to use module to manage 'HTTP(s)' Global/Public load balancers.

## Some key usage notes
- This module deploys ILB in SSL|HTTPS mode by default, and [http-to-https redirect](https://cloud.google.com/load-balancing/docs/https/setting-up-http-https-redirect) is enabled by default.
- By default GLBs are bound to DnB's default SSL policy, which offers `>= TLS1.2` and ciphers in [MODERN](https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy) profile.
- GLBs managed with this module requires [CloudArmor security policy](https://cloud.google.com/armor/docs/integrating-cloud-armor#https-iap) attachment, and by default will attach to `dnb-sp-cloudarmor-default-policy`, a default policy created in projects with org_policy execption granted to allow deploying GLBs. `dnb-sp-cloudarmor-default-policy` only allows traffic from Akamai sources.
- In order to deploy GLB in **non-prod** VPC, you need to first add your GCP project into the **Exception List of project ids that need public LB**. This list(**_public_http_lbs_enabled_project_ids_**) can be found by going to [landing-zone repo](https://github.com/dnb-main/devx-gcp-lz), **_terraform -> devx-gcp-landingzone-org-setup -> environments -> mainorg.tfvars_**. Please submit a Pull Request and once the addition of project ID to the tfvars file be merged, another terraform workspace run will be triggered to apply this change.
- GLBs provide the option to use [Google managed certificates](https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs). This module supports using managed certificates by default and user can explicity provide user managed certificated for GLBs(proxies) to offload SSL/TLS.
- Google managed certs [auto-renewal process](https://cloud.google.com/load-balancing/docs/ssl-certificates/google-managed-certs#renewal).

## Usage

```hcl
module "gce-lb-http" {
  source = "../.."

  project                         = var.project_id
  name                            = "https-lb"
  managed_ssl_certificate_domains = ["app.test.dnb.net"]
  backends = {
    default = {
      description     = "Test MIG backend group"
      protocol        = "HTTP"
      port            = 80
      port_name       = "http"
      timeout_sec     = 30
      enable_cdn      = false
      security_policy = "projects/${var.project_id}/global/securityPolicies/dnb-sp-cloudarmor-default-policy"

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = google_compute_instance_group_manager.default.instance_group
        }
      ]

      iap_config = {
        enable = false
      }
    }
  }
}
```

`certificate` and `private_key` are optional, and these can be either [self-signed](https://cloud.google.com/load-balancing/docs/ssl-certificates/self-managed-certs) or DnB's CA issued certs, which can be stored as secrets. Please refer to the example for additional usage details.

### References
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gce-lb-http"></a> [gce-lb-http](#module\_gce-lb-http) | GoogleCloudPlatform/lb-http/google | ~> 6.3 |

## Resources

| Name | Type |
|------|------|
| [google_compute_ssl_policy.dnb-ssl-policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address"></a> [address](#input\_address) | Existing IPv4 address to use (the actual IP address value) | `string` | `null` | no |
| <a name="input_backends"></a> [backends](#input\_backends) | Map backend indices to list of backend maps. | <pre>map(object({<br>    protocol  = string<br>    port      = number<br>    port_name = string<br><br>    description             = optional(string)<br>    enable_cdn              = bool<br>    security_policy         = string<br>    custom_request_headers  = optional(list(string))<br>    custom_response_headers = optional(list(string))<br><br>    timeout_sec                     = number<br>    connection_draining_timeout_sec = optional(number)<br>    session_affinity                = optional(string)<br>    affinity_cookie_ttl_sec         = optional(number)<br><br>    health_check = object({<br>      check_interval_sec  = optional(number)<br>      timeout_sec         = optional(number)<br>      healthy_threshold   = optional(number)<br>      unhealthy_threshold = optional(number)<br>      request_path        = string<br>      port                = number<br>      host                = optional(string)<br>      logging             = optional(bool)<br>    })<br><br>    log_config = object({<br>      enable      = bool<br>      sample_rate = number<br>    })<br><br>    groups = list(object({<br>      group = string<br><br>      balancing_mode               = optional(string)<br>      capacity_scaler              = optional(number)<br>      description                  = optional(string)<br>      max_connections              = optional(number)<br>      max_connections_per_instance = optional(number)<br>      max_connections_per_endpoint = optional(number)<br>      max_rate                     = optional(number)<br>      max_rate_per_instance        = optional(number)<br>      max_rate_per_endpoint        = optional(number)<br>      max_utilization              = optional(number)<br>    }))<br>    iap_config = object({<br>      enable               = bool<br>      oauth2_client_id     = optional(string)<br>      oauth2_client_secret = optional(string)<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_cdn"></a> [cdn](#input\_cdn) | Set to `true` to enable cdn on backend. | `bool` | `false` | no |
| <a name="input_certificate"></a> [certificate](#input\_certificate) | Content of the SSL certificate. Required if `ssl` is `true` and `ssl_certificates` is empty. | `string` | `null` | no |
| <a name="input_create_address"></a> [create\_address](#input\_create\_address) | Create a new global IPv4 address | `bool` | `true` | no |
| <a name="input_create_ipv6_address"></a> [create\_ipv6\_address](#input\_create\_ipv6\_address) | Allocate a new IPv6 address. Conflicts with "ipv6\_address" - if both specified, "create\_ipv6\_address" takes precedence. | `bool` | `false` | no |
| <a name="input_create_url_map"></a> [create\_url\_map](#input\_create\_url\_map) | Set to `false` if url\_map variable is provided. | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enable IPv6 address on the CDN load-balancer | `bool` | `false` | no |
| <a name="input_http_forward"></a> [http\_forward](#input\_http\_forward) | Set to `false` to disable HTTP port 80 forward | `bool` | `true` | no |
| <a name="input_https_redirect"></a> [https\_redirect](#input\_https\_redirect) | Set to `true` to enable https redirect on the lb. | `bool` | `true` | no |
| <a name="input_ipv6_address"></a> [ipv6\_address](#input\_ipv6\_address) | An existing IPv6 address to use (the actual IP address value) | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The labels to attach to resources created by this module | `map(string)` | `{}` | no |
| <a name="input_managed_ssl_certificate_domains"></a> [managed\_ssl\_certificate\_domains](#input\_managed\_ssl\_certificate\_domains) | Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the forwarding rule and prefix for supporting resources | `string` | n/a | yes |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Content of the private SSL key. Required if `ssl` is `true` and `ssl_certificates` is empty. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | The project to deploy to, if not set the default provider project is used. | `string` | n/a | yes |
| <a name="input_quic"></a> [quic](#input\_quic) | Set to `true` to enable QUIC support | `bool` | `false` | no |
| <a name="input_random_certificate_suffix"></a> [random\_certificate\_suffix](#input\_random\_certificate\_suffix) | Bool to enable/disable random certificate name generation. Set and keep this to true if you need to change the SSL cert. | `bool` | `false` | no |
| <a name="input_ssl"></a> [ssl](#input\_ssl) | Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self\_link certs | `bool` | `true` | no |
| <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates) | SSL cert self\_link list. Required if `ssl` is `true` and no `private_key` and `certificate` is provided. | `list(string)` | `[]` | no |
| <a name="input_ssl_custom_features"></a> [ssl\_custom\_features](#input\_ssl\_custom\_features) | List of custom ciphers. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy | `list(string)` | `[]` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Selfink to SSL Policy | `string` | `null` | no |
| <a name="input_ssl_profile"></a> [ssl\_profile](#input\_ssl\_profile) | SSL Profile. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy | `string` | `"MODERN"` | no |
| <a name="input_url_map"></a> [url\_map](#input\_url\_map) | The url\_map resource to use. Default is to send all traffic to first backend. | `string` | `null` | no |
| <a name="input_use_ssl_certificates"></a> [use\_ssl\_certificates](#input\_use\_ssl\_certificates) | If true, use the certificates provided by `ssl_certificates`, otherwise, create cert from `private_key` and `certificate` | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_ip"></a> [external\_ip](#output\_external\_ip) | The external IPv4 assigned to the global fowarding rule. |
| <a name="output_https_proxy"></a> [https\_proxy](#output\_https\_proxy) | HTTPS proxy used by the GLB. |
| <a name="output_url_map"></a> [url\_map](#output\_url\_map) | URL map bound to the GCL. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
