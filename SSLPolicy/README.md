# terraform-google-dnb_gcp_ssl_policy

Represents a SSL policy. SSL policies give you the ability to control the features of SSL that your SSL proxy or HTTPS load balancer negotiates.

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

### Required Providers

The template repo contains a few required providers for the module repo, which specify module version ranges in the `./versions.tf` file. Versions will be updated and maintained by Dependabot. If unneeded for the given module, remove from the `./versions.tf` file in order to prevent unnecessary provider downloads during `terraform init`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.52.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.52.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.52.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_region_ssl_policy.regional-ssl-policy](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_ssl_policy) | resource |
| [google_compute_ssl_policy.global-ssl-policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the resource belongs | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | SSL policy region | `string` | n/a | yes |
| <a name="input_ssl_min_tls_version"></a> [ssl\_min\_tls\_version](#input\_ssl\_min\_tls\_version) | The minimum version of SSL protocol. Possible values are TLS\_1\_0, TLS\_1\_1, and TLS\_1\_2 | `string` | `"TLS_1_2"` | no |
| <a name="input_ssl_policy_global"></a> [ssl\_policy\_global](#input\_ssl\_policy\_global) | ssl policy type, true for global | `bool` | n/a | yes |
| <a name="input_ssl_policy_name"></a> [ssl\_policy\_name](#input\_ssl\_policy\_name) | Name of SSL policy | `string` | n/a | yes |
| <a name="input_ssl_profile"></a> [ssl\_profile](#input\_ssl\_profile) | Profile for SSL policy - Default value is COMPATIBLE. Possible values are COMPATIBLE, MODERN, RESTRICTED, and CUSTOM | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region"></a> [region](#output\_region) | Name of a region |
| <a name="output_ssl_policy_name"></a> [ssl\_policy\_name](#output\_ssl\_policy\_name) | Name of SSL Policy |
| <a name="output_tls_version"></a> [tls\_version](#output\_tls\_version) | Minimum TLS version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
