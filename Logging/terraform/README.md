<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.10.0, <5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 4.10.0, <5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 4.10.0, <5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_folder.folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_org_policy_policy.compute_disableInternetNetworkEndpointGroup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_org_policy_policy.compute_skipDefaultNetworkCreation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_org_policy_policy.compute_vmExternalIpAccess](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_org_policy_policy.detailedAuditLoggingMode](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_org_policy_policy.disableAllIpv6](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_org_policy_policy.resourcemanager_accessBoundaries](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_org_policy_policy.storage_publicAccessPrevention](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_org_policy_policy.storage_uniformBucketLevelAccess](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/org_policy_policy) | resource |
| [google_organization_iam_binding.organization_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_binding) | resource |
| [google_project_service.project_services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_folders"></a> [folders](#input\_folders) | List of folders to create | `list(string)` | <pre>[<br>  "nonprod",<br>  "prod",<br>  "sandbox"<br>]</pre> | no |
| <a name="input_org_admin_email"></a> [org\_admin\_email](#input\_org\_admin\_email) | email address for org administrator | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Numeric ID of Organization | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project to run admin commands against | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Default region | `string` | `"us-central1"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Default zone | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_folder_ids"></a> [folder\_ids](#output\_folder\_ids) | n/a |
| <a name="output_organization_id"></a> [organization\_id](#output\_organization\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->