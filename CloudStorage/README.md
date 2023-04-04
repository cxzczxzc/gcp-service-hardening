# terraform-module-repo-template
A repo template for terraform modules

The repo name should follow naming convention:

        terraform-<PROVIDER>-dnb_<servicename>

e.g.
        terraform-google-dnb_gcp_cloud_storage

And provide a short description of the purpose here. The module will need to be submitted to the DevX Platform team for peer-review via a pull-request, and then they can add it to our dnb-core TFC module registry.


## Quick Start

Test module locally:
```
make test
```

Apply configuration to currently configured/authenticated GCP ENV:
```
make test-apply
```

Destroy configuration from currently configured/authenticated GCP ENV:
```
make clean
```

## Module Documentation
[Terraform docs](https://github.com/terraform-docs/terraform-docs) is used to ensure proper module documentation.

## Contributing


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.15, <5.0 |
| <a name="requirement_checkov"></a> [checkov](#requirement\_checkov) | >= 2.3.124 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.15, <5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Resources

| Name | Type |
|------|------|
| [google_pubsub_topic_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_binding) | resource |
| [google_storage_notification.notification](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification) | resource |
| [null_resource.storage_class_validation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_storage_project_service_account.gcs_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_project_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cors"></a> [cors](#input\_cors) | Configuration of CORS for bucket with structure as defined in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket#cors. | `any` | `[]` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | A Cloud KMS key that will be used to encrypt objects inserted into this bucket | <pre>object({<br>    default_kms_key_name = string<br>  })</pre> | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Project environment (prod, nonprod, sandbox). | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects when set to true. If this value is set to false and you try to delete a bucket that contains objects, Terraform will fail. | `bool` | `false` | no |
| <a name="input_iam_members"></a> [iam\_members](#input\_iam\_members) | The list of IAM members to grant permissions on the bucket. Inherits project permissions by default. | <pre>list(object({<br>    role   = string<br>    member = string<br>  }))</pre> | `[]` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of key/value label pairs to assign to the bucket. | `map(string)` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | The bucket's Lifecycle Rules configuration. | <pre>list(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = any<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Storage Class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    condition = any<br>  }))</pre> | <pre>[<br>  {<br>    "action": {<br>      "type": "Delete"<br>    },<br>    "condition": {<br>      "age": 30,<br>      "num_newer_versions": 2,<br>      "with_state": "ARCHIVED"<br>    }<br>  }<br>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the bucket. | `string` | `"us-east4"` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | The bucket that will receive log objects. | `string` | `null` | no |
| <a name="input_log_object_prefix"></a> [log\_object\_prefix](#input\_log\_object\_prefix) | The object prefix for log objects. If it's not provided, by default GCS sets this to this bucket's name | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the bucket. Takes preference over prefix\_name | `string` | `""` | no |
| <a name="input_notification_pubsub_topics"></a> [notification\_pubsub\_topics](#input\_notification\_pubsub\_topics) | Map including the topic name as a string and notification events as list of any of the following: OBJECT\_FINALIZE, OBJECT\_METADATA\_UPDATE, OBJECT\_DELETE, OBJECT\_ARCHIVE. | <pre>map(object({<br>    topic               = string<br>    notification_events = list(string)<br><br>  }))</pre> | `{}` | no |
| <a name="input_prefix_name"></a> [prefix\_name](#input\_prefix\_name) | The prefix name of the bucket.  A random suffix will be generated. Conflicts with 'name' which takes precedence | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project to create the bucket in. | `string` | n/a | yes |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | The Storage Class of the new bucket. | `string` | `"STANDARD"` | no |
| <a name="input_website"></a> [website](#input\_website) | Map of website values. Supported attributes: main\_page\_suffix, not\_found\_page | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The created storage bucket |
| <a name="output_encryption"></a> [encryption](#output\_encryption) | The created storage bucket's access level |
| <a name="output_retention_policy"></a> [retention\_policy](#output\_retention\_policy) | The created storage bucket's retention policy |
| <a name="output_storage_class"></a> [storage\_class](#output\_storage\_class) | The created storage bucket's storage class |
| <a name="output_storage_notification"></a> [storage\_notification](#output\_storage\_notification) | The created storage notification self\_link for the bucket |
| <a name="output_versioning"></a> [versioning](#output\_versioning) | The created storage bucket's versioning status |
| <a name="output_not_public"></a> [not\_public](#output\_not\_public) | The created storage bucket's public access prevention |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->