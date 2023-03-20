# terraform-google-dnb_gcp_cloud_sql

Submodule to create gcp cloud sql database and current version of module supports only mssql.

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


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.18.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.18.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mssql-db"></a> [mssql-db](#module\_mssql-db) | GoogleCloudPlatform/sql-db/google//modules/mssql | ~> 12.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_directory_config"></a> [active\_directory\_config](#input\_active\_directory\_config) | Active domain that the SQL instance will join. This block supports: domain = "ad.domain.com" . More info about [Managed Microsoft AD in Cloud SQL](https://cloud.google.com/sql/docs/sqlserver/ad), more info about [configuring AD for CLoud SQL.](https://cloud.google.com/sql/docs/sqlserver/configure-ad) | `map(string)` | `{}` | no |
| <a name="input_allocated_ip_range"></a> [allocated\_ip\_range](#input\_allocated\_ip\_range) | The name of the allocated ip range for the private ip cloud sql instance. This is related to the PSA configuration and will be used by service producers, such as Cloud SQL. The private connection enables VM instances in your VPC network and the services that you access to communicate exclusively by using internal IP addresses. This PSA configuration is managed in the shared VPC module https://github.com/dnb-main/terraform-google-dnb_gcp_shared_vpc/blob/main/main.tf#L325 . | `string` | n/a | yes |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs | `list(map(string))` | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type for the master instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | The optional timout that is applied to limit long database creates. | `string` | `"20m"` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/sqlserver/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the SQL Database instance | `string` | n/a | yes |
| <a name="input_db_tier"></a> [db\_tier](#input\_db\_tier) | The tier for the master instance. | `string` | `"db-f1-micro"` | no |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | The database version to use: SQLSERVER\_2017\_STANDARD, SQLSERVER\_2017\_ENTERPRISE, SQLSERVER\_2017\_EXPRESS, or SQLSERVER\_2017\_WEB | `string` | n/a | yes |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | The optional timout that is applied to limit long database deletes. | `string` | `"20m"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The disk size for the master instance. | `number` | `10` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which resources will be provisioned. | `string` | n/a | yes |
| <a name="input_random_instance_name"></a> [random\_instance\_name](#input\_random\_instance\_name) | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| <a name="input_require_ssl"></a> [require\_ssl](#input\_require\_ssl) | For public IP network, SSL encryption is required | `bool` | `true` | no |
| <a name="input_shared_vpc_id"></a> [shared\_vpc\_id](#input\_shared\_vpc\_id) | The ID of the Shared VPC. | `string` | n/a | yes |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | The optional timout that is applied to limit long database updates. | `string` | `"20m"` | no |
| <a name="input_user_labels"></a> [user\_labels](#input\_user\_labels) | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mssql_conn"></a> [mssql\_conn](#output\_mssql\_conn) | The connection name of the master instance to be used in connection strings |
| <a name="output_mssql_user_pass"></a> [mssql\_user\_pass](#output\_mssql\_user\_pass) | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. |
| <a name="output_name"></a> [name](#output\_name) | The name for Cloud SQL instance |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address assigned for the master instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->