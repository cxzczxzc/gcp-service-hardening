<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.18.0, <5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_exception_role_grants_for_dap"></a> [exception\_role\_grants\_for\_dap](#module\_exception\_role\_grants\_for\_dap) | ./modules/exception_role_grants | n/a |
| <a name="module_gcp_delegated_role_grant"></a> [gcp\_delegated\_role\_grant](#module\_gcp\_delegated\_role\_grant) | ./modules/gcp_iam_delegated_role_grants | n/a |

## Resources

| Name | Type |
|------|------|
| [http_http.devx_project_data](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dap_exception_group"></a> [dap\_exception\_group](#input\_dap\_exception\_group) | The group which would be assigned exception role(s) for DAP projects | `string` | n/a | yes |
| <a name="input_dap_projects"></a> [dap\_projects](#input\_dap\_projects) | List of DAP projects. These projects are assigned additional Firestore roles, as an exception | `list(string)` | `[]` | no |
| <a name="input_delegated_role_grants"></a> [delegated\_role\_grants](#input\_delegated\_role\_grants) | The list of roles the devx service account will be able to grant to other priciples within the given project | `list(string)` | `[]` | no |
| <a name="input_devx_api_token"></a> [devx\_api\_token](#input\_devx\_api\_token) | The secret token for access to DevX rest API | `string` | `"password"` | no |
| <a name="input_devx_projects_base_url"></a> [devx\_projects\_base\_url](#input\_devx\_projects\_base\_url) | Base URL of devx api to acquire vended project info | `string` | n/a | yes |
| <a name="input_direct_role_grants"></a> [direct\_role\_grants](#input\_direct\_role\_grants) | The list of roles to be granted to the devx service account directly | `list(string)` | `[]` | no |
| <a name="input_drg_enabled_projects"></a> [drg\_enabled\_projects](#input\_drg\_enabled\_projects) | A list of projects that will have the DRG IAM feature available | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The string value of the environment to deploy DRG to | `string` | n/a | yes |
| <a name="input_exception_roles_for_DAP"></a> [exception\_roles\_for\_DAP](#input\_exception\_roles\_for\_DAP) | A list of roles that would be assigned to a DAP group, to enable console access to certain services | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project id the terraform will be run in the context of | `string` | n/a | yes |
| <a name="input_viewer_group_role_assignment"></a> [viewer\_group\_role\_assignment](#input\_viewer\_group\_role\_assignment) | List of roles assigned to the viewer group at the project level | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->