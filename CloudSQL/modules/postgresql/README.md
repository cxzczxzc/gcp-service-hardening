# terraform-google-dnb_gcp_cloud_sql

Module to create gcp cloud sql database and current version of module supports only postgresql

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
| <a name="module_postgresql-db"></a> [postgresql-db](#module\_postgresql-db) | GoogleCloudPlatform/sql-db/google//modules/postgresql | 11.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs | `list(map(string))` | <pre>[<br>  {<br>    "name": "sample-gcp-health-checkers-range",<br>    "value": "130.211.0.0/28"<br>  }<br>]</pre> | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type of the Cloud SQL instance. Can be either single zone `ZONAL` or high availability `REGIONAL`. | `string` | `"ZONAL"` | no |
| <a name="input_backup_configuration"></a> [backup\_configuration](#input\_backup\_configuration) | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = bool<br>    start_time                     = string<br>    location                       = string<br>    point_in_time_recovery_enabled = bool<br>    transaction_log_retention_days = string<br>    retained_backups               = number<br>    retention_unit                 = string<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "location": null,<br>  "point_in_time_recovery_enabled": true,<br>  "retained_backups": 7,<br>  "retention_unit": "COUNT",<br>  "start_time": null,<br>  "transaction_log_retention_days": "7"<br>}</pre> | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | The optional timout that is applied to limit long database creates. | `string` | `"20m"` | no |
| <a name="input_database_flags"></a> [database\_flags](#input\_database\_flags) | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "log_connections",<br>    "value": "on"<br>  },<br>  {<br>    "name": "log_disconnections",<br>    "value": "on"<br>  },<br>  {<br>    "name": "log_statement",<br>    "value": "ddl"<br>  }<br>]</pre> | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the SQL Database instance | `string` | n/a | yes |
| <a name="input_db_tier"></a> [db\_tier](#input\_db\_tier) | The tier for the master instance. | `string` | `"db-custom-4-15360"` | no |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | The database version to use | `string` | `"POSTGRES_14"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | The optional timout that is applied to limit long database deletes. | `string` | `"20m"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The disk size for the master instance. | `number` | `10` | no |
| <a name="input_encryption_key_name"></a> [encryption\_key\_name](#input\_encryption\_key\_name) | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| <a name="input_maintenance_window_day"></a> [maintenance\_window\_day](#input\_maintenance\_window\_day) | The day of week (1-7) for the master instance maintenance. | `number` | `7` | no |
| <a name="input_maintenance_window_hour"></a> [maintenance\_window\_hour](#input\_maintenance\_window\_hour) | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `4` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the VPC network to peer. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which resources will be provisioned. | `string` | n/a | yes |
| <a name="input_random_instance_name"></a> [random\_instance\_name](#input\_random\_instance\_name) | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| <a name="input_require_ssl"></a> [require\_ssl](#input\_require\_ssl) | For public IP network, SSL encryption is required | `bool` | `true` | no |
| <a name="input_shared_vpc_project_id"></a> [shared\_vpc\_project\_id](#input\_shared\_vpc\_project\_id) | The ID of the Shared VPC project. | `string` | n/a | yes |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | The optional timout that is applied to limit long database updates. | `string` | `"20m"` | no |
| <a name="input_user_labels"></a> [user\_labels](#input\_user\_labels) | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the Shared VPC. | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The name for Cloud SQL instance |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The project to run tests against |
| <a name="output_psql_conn"></a> [psql\_conn](#output\_psql\_conn) | The connection name of the master instance to be used in connection strings |
| <a name="output_psql_user_pass"></a> [psql\_user\_pass](#output\_psql\_user\_pass) | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The first public (PRIMARY) IPv4 address assigned for the master instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->