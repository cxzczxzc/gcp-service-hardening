# terraform-google-dnb_gcp_secret_manager



This module use to create and managing secret values in GCP Secret Manager.
This example shows how to use the Terraform random provider to generate a random secret value which is replication automatically.


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
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.18.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.18.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.18.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [random_password.secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessors"></a> [accessors](#input\_accessors) | An optional list of IAM account identifiers that will be granted accessor (read-only) permission to the secret | `list(string)` | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | An optional map of label key:value pairs to assign to the secret resources. Default is an empty map | `map(string)` | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project identifier where the secret will be created | `string` | n/a | yes |
| <a name="input_replication"></a> [replication](#input\_replication) | An optional map of replication configurations for the secret. If the map is empty<br>(default), then automatic replication will be used for the secret. If the map is<br>not empty, replication will be configured for each key (region) and, optionally,<br>will use the provided Cloud KMS keys.<br>NOTE: If Cloud KMS keys are used, a Cloud KMS key must be provided for every<br>region key.<br>E.g. to use automatic replication policy (default)<br>replication = {}<br>E.g. to force secrets to be replicated only in us-east1 and us-west1 regions,<br>with Google managed encryption keys<br>replication = {<br>  "us-east1" = null<br>  "us-west1" = null<br>}<br>E.g. to force secrets to be replicated only in us-east1 and us-west1 regions, but<br>use Cloud KMS keys from each region.<br>replication = {<br>  "us-east1" = { kms\_key\_name = "my-east-key-name" }<br>  "us-west1" = { kms\_key\_name = "my-west-key-name" }<br>} | <pre>map(object({<br>    kms_key_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_secret_data"></a> [secret\_data](#input\_secret\_data) | The secret data in the secret version | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The secret identifier to create; this value must be unique within the project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret manager |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
