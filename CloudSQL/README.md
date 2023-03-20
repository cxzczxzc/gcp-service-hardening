# terraform-google-sql
terraform-google-sql makes it easy to create Google CloudSQL instance and implement high availability settings. This module consists of the following submodules:

 - [mysql](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_sql/tree/mysql-commits/modules/mysql)
 - [postgresql](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_sql/tree/mysql-commits/modules/postgresql)

 ## Update DB_Instance Name

 For future testing of the module, update the db_name in all test modules.
 Any new PR or update to this existing PR will fail with error "You cannot reuse an instance name for up to a week after you have deleted an instance."

## Compatibility 

This module is meant for use with Terraform 1.1.0+ and tested using Terraform 1.1.0+. If you find incompatibilities using Terraform >=1.1.0, please open an issue.

## Requirements


### Installation Dependencies


- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin >= v4.4.0

The following dependency must be available for SQL Server module:

- [Terraform Provider Beta for GCP](https://github.com/terraform-providers/terraform-provider-google-beta) plugin >= v4.22.0

### Enable APIs  

In order to operate with the Service Account/IAM User you must activate the following APIs on the project where the Service Account/IAM Users was created:

- Cloud SQL Admin API: `sqladmin.googleapis.com`

In order to use Private Service Access, required for using Private IPs, you must activate
the following APIs on the service project :

- Cloud SQL Admin API: `sqladmin.googleapis.com`
- Compute Engine API: `compute.googleapis.com`
- Service Networking API: `servicenetworking.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
