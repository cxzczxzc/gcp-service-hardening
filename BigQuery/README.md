# terraform-google-dnb_gcp_bigquery
This module will create BigQuery datasets and tables. This will allow the user to programmatically create an empty table schema inside of a dataset, ready for loading. Additional user accounts and permissions are necessary to begin querying the newly created table(s)

BigQuery documentations is available here: https://cloud.google.com/bigquery/docs

Added a new feature here which is assigning the role of "bigquery.dataEditor" to sink member if any user wants to utilize bigquery as a "sink destination".

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
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.27.0, <5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.27.0, <5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bigquery"></a> [bigquery](#module\_bigquery) | terraform-google-modules/bigquery/google | ~> 5.4.0 |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.bigquery_sink_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | An array of objects that define dataset access for one or more entities. | `any` | <pre>[<br>  {<br>    "role": "roles/bigquery.dataOwner",<br>    "special_group": "projectOwners"<br>  }<br>]</pre> | no |
| <a name="input_dataset_id"></a> [dataset\_id](#input\_dataset\_id) | Unique ID for the dataset being provisioned. | `string` | n/a | yes |
| <a name="input_dataset_labels"></a> [dataset\_labels](#input\_dataset\_labels) | Key value pairs in a map for dataset labels | `map(string)` | `{}` | no |
| <a name="input_dataset_name"></a> [dataset\_name](#input\_dataset\_name) | Friendly name for the dataset being provisioned. | `string` | n/a | yes |
| <a name="input_delete_contents_on_destroy"></a> [delete\_contents\_on\_destroy](#input\_delete\_contents\_on\_destroy) | (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present. | `bool` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Dataset description. | `string` | n/a | yes |
| <a name="input_external_tables"></a> [external\_tables](#input\_external\_tables) | A list of objects which include table\_id, expiration\_time, external\_data\_configuration, and labels. | <pre>list(object({<br>    table_id              = string,<br>    autodetect            = bool,<br>    compression           = string,<br>    ignore_unknown_values = bool,<br>    max_bad_records       = number,<br>    schema                = string,<br>    source_format         = string,<br>    source_uris           = list(string),<br>    csv_options = object({<br>      quote                 = string,<br>      allow_jagged_rows     = bool,<br>      allow_quoted_newlines = bool,<br>      encoding              = string,<br>      field_delimiter       = string,<br>      skip_leading_rows     = number,<br>    }),<br>    google_sheets_options = object({<br>      range             = string,<br>      skip_leading_rows = number,<br>    }),<br>    hive_partitioning_options = object({<br>      mode              = string,<br>      source_uri_prefix = string,<br>    }),<br>    expiration_time = string,<br>    labels          = map(string),<br>  }))</pre> | `[]` | no |
| <a name="input_local_value"></a> [local\_value](#input\_local\_value) | To pass true or false value whether to have sink destination or not | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The regional location for the dataset only US and EU are allowed in module | `string` | `"US"` | no |
| <a name="input_log_sink_writer_identity"></a> [log\_sink\_writer\_identity](#input\_log\_sink\_writer\_identity) | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | `string` | `"test"` | no |
| <a name="input_materialized_views"></a> [materialized\_views](#input\_materialized\_views) | A list of objects which includes view\_id, view\_query, clustering, time\_partitioning, range\_partitioning, expiration\_time and labels | <pre>list(object({<br>    view_id             = string,<br>    query               = string,<br>    enable_refresh      = bool,<br>    refresh_interval_ms = string,<br>    clustering          = list(string),<br>    time_partitioning = object({<br>      expiration_ms            = string,<br>      field                    = string,<br>      type                     = string,<br>      require_partition_filter = bool,<br>    }),<br>    range_partitioning = object({<br>      field = string,<br>      range = object({<br>        start    = string,<br>        end      = string,<br>        interval = string,<br>      }),<br>    }),<br>    expiration_time = string,<br>    labels          = map(string),<br>  }))</pre> | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project where the dataset and table are created | `string` | n/a | yes |
| <a name="input_routines"></a> [routines](#input\_routines) | A list of objects which include routine\_id, routine\_type, routine\_language, definition\_body, return\_type, routine\_description and arguments. | <pre>list(object({<br>    routine_id      = string,<br>    routine_type    = string,<br>    language        = string,<br>    definition_body = string,<br>    return_type     = string,<br>    description     = string,<br>    arguments = list(object({<br>      name          = string,<br>      data_type     = string,<br>      argument_kind = string,<br>      mode          = string,<br>    })),<br>  }))</pre> | `[]` | no |
| <a name="input_tables"></a> [tables](#input\_tables) | A list of objects which include table\_id, schema, clustering, time\_partitioning, range\_partitioning, expiration\_time and labels. | <pre>list(object({<br>    table_id   = string,<br>    schema     = string,<br>    clustering = list(string),<br>    time_partitioning = object({<br>      expiration_ms            = string,<br>      field                    = string,<br>      type                     = string,<br>      require_partition_filter = bool,<br>    }),<br>    range_partitioning = object({<br>      field = string,<br>      range = object({<br>        start    = string,<br>        end      = string,<br>        interval = string,<br>      }),<br>    }),<br>    expiration_time = string,<br>    labels          = map(string),<br>  }))</pre> | `[]` | no |
| <a name="input_views"></a> [views](#input\_views) | A list of objects which include view\_id and view query | <pre>list(object({<br>    view_id        = string,<br>    query          = string,<br>    use_legacy_sql = bool,<br>    labels         = map(string),<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bigquery_dataset"></a> [bigquery\_dataset](#output\_bigquery\_dataset) | Bigquery dataset resource. |
| <a name="output_bigquery_tables"></a> [bigquery\_tables](#output\_bigquery\_tables) | Map of bigquery table resources being provisioned. |
| <a name="output_destination_uri"></a> [destination\_uri](#output\_destination\_uri) | The destination URI for the bigquery dataset. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->