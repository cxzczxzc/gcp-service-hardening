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

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.dap_exception_group_role_assignment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exception_group"></a> [exception\_group](#input\_exception\_group) | This group will be assigned roles that are edge cases/exceptions | `string` | n/a | yes |
| <a name="input_exception_roles"></a> [exception\_roles](#input\_exception\_roles) | A list of roles that would be assigned to a group on exception basis, to enable console access to certain services | `list(string)` | <pre>[<br>  "roles/datastore.owner"<br>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id of DAP Projects | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_exception_roles"></a> [exception\_roles](#output\_exception\_roles) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->