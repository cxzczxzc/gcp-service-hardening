# terraform-google-dnb_gcp_project_iam

This module is intended to be used on your DevX vended projects to bind approved IAM roles to GCP Service Accounts. 
It also prevents granting roles to humans or groups, enabling a design in accordance with the principle of least privilege.

## Quick Start

To use this module you will require:
1. A GCP project
2. A Github repository to call this module
3. A TFC workspace connected to both your project and repository
4. The email IDs of the service accounts you wish to apply IAM roles to

With all of the above, you can use the following code example as a guide to working with the module:

```terraform
module "gcp_project_iam" {
  source = "app.terraform.io/dnb-core/dnb_gcp_project_iam"
  version = "0.1.0" # Use the newest version available (can be found in releases list)

  project_id = var.project_id

  sa_bindings = {
    binding-set-1 = {
      service_account_email = <my-sa-1>@<my-project-id>.iam.gserviceaccount.com
      roles                 = ["roles/container.admin"]
      condition = {
        expression  = "request.time < timestamp(\"2022-10-01T00:00:00Z\")"
        title       = "expire_end_september"
        description = "Role access expires at the end of September 2020"

      }
    },
    binding-set-2 = {
      service_account_email = <my-sa-2>@<my-project-id>.iam.gserviceaccount.com
      roles                 = ["roles/container.admin", "roles/container.developer"]
    }
    bq_viewer_for_sa_1 = {
      service_account_email = <my-sa-1>@<my-project-id>.iam.gserviceaccount.com
      roles                 = ["roles/bigquery.dataViewer"]
    }
}

```

### Notes for using the module

1. For the role binding variables, the input is a map of objects. Feel free to use the key as a quick reference for the binding's purpose like `bq_viewer_for_sa_1`
  1. Changing the key will cause the binding to be recreated
3. If you use a condition, the condition will be applied to all roles listed in the binding
4. If you want to grant one principal a conditional role, and a second role without a condition, use a second binding to separate
5. Currently, this module only applies IAM roles at the project level, it cannot bind roles to individual resources
6. **If you try to new create service accounts** and assign roles at the same time, it would not work. This is because there's a condition that validates the service account's email address, and it errors with the `known after apply` message. To avoid this :- create your service accounts first, then use this module to apply the role.

### What Roles Can I Use?

The roles that can be used are defined by the environment in which you are deploying to in the DevX GCP platform. This 
configuration is currently defined in the [landing zone repo](https://github.com/dnb-main/devx-gcp-lz/blob/main/terraform/project-vending-drg/environments/mainorg-nonprod.tfvars). Here you will be able to find the list of allowed
roles that are compatible with this module

### How Do I Use IAM Conditions

[The GCP docs](https://cloud.google.com/iam/docs/conditions-overview) are a great starting point to working with GCP IAM roles

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | = 4.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | = 4.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.sa_role_bindings](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/project_iam_member) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project in which the bindings will be made. If not given, the provider project ID will be used. | `string` | `""` | no |
| <a name="input_service_account_bindings"></a> [service\_account\_bindings](#input\_service\_account\_bindings) | n/a | <pre>map(object({<br>    roles                 = list(string)<br>    service_account_email = string<br><br>    condition = optional(object({<br>      expression  = string<br>      title       = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_sa_bindings"></a> [all\_sa\_bindings](#output\_all\_sa\_bindings) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
