# storage Cloud Function Terraform submodule

This submodule creates a cloud function that can be called by a storage bucket object event.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7, < 2.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.52.0, != 4.53.0, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.52.0, != 4.53.0, < 5.0.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dnb_gcp_shared_constants"></a> [dnb\_gcp\_shared\_constants](#module\_dnb\_gcp\_shared\_constants) | app.terraform.io/dnb-core/dnb_gcp_shared_constants/google | 2.1.1 |

## Resources

| Name | Type |
|------|------|
| [google_cloudfunctions_function.storagefunction](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function) | resource |
| [google_cloudfunctions_function_iam_member.storageinvoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function_iam_member) | resource |
| [google_service_account.cloud_function_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [null_resource.service_account_email_validation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Service account id to invoke cloud function | `string` | n/a | yes |
| <a name="input_available_memory_mb"></a> [available\_memory\_mb](#input\_available\_memory\_mb) | Memory (in MB), available to the function. | `number` | n/a | yes |
| <a name="input_build_environment_variables"></a> [build\_environment\_variables](#input\_build\_environment\_variables) | key/value pairs that will be available as environment variables at build time. | `map(any)` | `{}` | no |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | Name of the function that will be executed when the Google Cloud Function is triggered | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment stage | `string` | `"non_prod"` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | key/value pairs that will be set as environment variables. | `map(any)` | `{}` | no |
| <a name="input_function-description"></a> [function-description](#input\_function-description) | Tells what type of function invoke | `string` | n/a | yes |
| <a name="input_function-name"></a> [function-name](#input\_function-name) | Name of the function | `string` | n/a | yes |
| <a name="input_function_trigger_bucket"></a> [function\_trigger\_bucket](#input\_function\_trigger\_bucket) | The GCS bucket triggers the function. | `string` | n/a | yes |
| <a name="input_ingress_settings"></a> [ingress\_settings](#input\_ingress\_settings) | String value that controls what traffic can reach the function | `string` | `"ALLOW_INTERNAL_ONLY"` | no |
| <a name="input_max_instances"></a> [max\_instances](#input\_max\_instances) | The limit on the maximum number of function instances that may coexist at a given time. | `number` | `1` | no |
| <a name="input_min_instances"></a> [min\_instances](#input\_min\_instances) | The limit on the minimum number of function instances that may coexist at a given time. | `number` | `1` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Id of the project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region name | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime in which the function is going to run | `string` | n/a | yes |
| <a name="input_secret_environment_variables"></a> [secret\_environment\_variables](#input\_secret\_environment\_variables) | Keys from the secret manager that will be set as secret environment variables. | <pre>list(object({<br>    name       = string<br>    project_id = string<br>    version    = string<br>    secret     = string<br>  }))</pre> | `[]` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Service account to run the function with | `string` | `null` | no |
| <a name="input_shared_constants_environment"></a> [shared\_constants\_environment](#input\_shared\_constants\_environment) | The environment name that we want to know about its constants.  Accepted values are "sandbox", "nonprod", or "prod". | `string` | n/a | yes |
| <a name="input_shared_constants_file"></a> [shared\_constants\_file](#input\_shared\_constants\_file) | The constants file name, where the constant are stored as JSON file with key/values that Terraform can interpret. | `string` | `"config.json"` | no |
| <a name="input_shared_constants_gcs_bucket"></a> [shared\_constants\_gcs\_bucket](#input\_shared\_constants\_gcs\_bucket) | The GCS bucket name that contains the constants file. | `string` | n/a | yes |
| <a name="input_shared_constants_region"></a> [shared\_constants\_region](#input\_shared\_constants\_region) | The region name that we want to know about its constants.  Accepted values are "asia-pacific", "europe", or "north-america". | `string` | n/a | yes |
| <a name="input_source_archive_bucket"></a> [source\_archive\_bucket](#input\_source\_archive\_bucket) | The GCS bucket containing the zip archive which contains the function. | `string` | n/a | yes |
| <a name="input_source_archive_object"></a> [source\_archive\_object](#input\_source\_archive\_object) | The source archive object (file) in archive bucket. | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout (in seconds) for the function | `number` | n/a | yes |
| <a name="input_vpc_connector_egress_settings"></a> [vpc\_connector\_egress\_settings](#input\_vpc\_connector\_egress\_settings) | The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are ALL\_TRAFFIC and PRIVATE\_RANGES\_ONLY. If unset, this field preserves the previously set value. | `string` | `"PRIVATE_RANGES_ONLY"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfunction_id"></a> [cloudfunction\_id](#output\_cloudfunction\_id) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->