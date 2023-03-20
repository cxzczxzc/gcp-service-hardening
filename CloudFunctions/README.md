# terraform-google-dnb_gcp_cloud_function

This repo contains submodules to create cloud functions that can be called in different ways:
- http
- pubsub
- storage

It is expected for the cloud function to use a VPC connector that uses a subnet from the host networking Shared VPC project, so in order to provision the cloud function you should configure previously the expected Service Account, Service Agent, IAM roles and APIs as documented in the [Shared VPC configuration](#shared-vpc-cluster-configuration) section.

## Quick Start

Run an only-plan test:
```
make test
```

Run a plan-apply-destroy test:
```
make test-apply
```

## Module Documentation

### Shared Vpc configuration

#### VPC connectors

We use the [`shared_constants` module 2.1.1](https://github.com/dnb-main/terraform-google-dnb_gcp_shared_constants/releases/tag/2.1.1) in order to retrieve some of the network configurations available.

In order to select an existing VPC connector, we rely on the following construct ([provision_httpfunc](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_function/blob/77e841cc9488cf37fb922677f852c44686e0a945/modules/provision_httpfunc/main.tf#L1-L12), [provision_pubsubfunc](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_function/blob/77e841cc9488cf37fb922677f852c44686e0a945/modules/provision_pubsubfunc/main.tf#L1-L12), and [provision_storagefunc](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_function/blob/77e841cc9488cf37fb922677f852c44686e0a945/modules/provision_storagefunc/main.tf#L1-L12)):

```
locals {
  vpc_connector_name = module.dnb_gcp_shared_constants.network.vpc_connectors.pod0[var.region]
}

module "dnb_gcp_shared_constants" {
  source         = "app.terraform.io/dnb-core/dnb_gcp_shared_constants/google"
  version        = "2.1.1"
  constants_file = var.shared_constants_file
  environment    = var.shared_constants_environment
  gcs_bucket     = var.shared_constants_gcs_bucket
  region         = var.shared_constants_region
}
```

Then we can reference the VPC connector name during the creation of the resources ([provision_httpfunc](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_function/blob/77e841cc9488cf37fb922677f852c44686e0a945/modules/provision_httpfunc/main.tf#L49), [provision_pubsubfunc](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_function/blob/77e841cc9488cf37fb922677f852c44686e0a945/modules/provision_pubsubfunc/main.tf#L51), and [provision_storagefunc](https://github.com/dnb-main/terraform-google-dnb_gcp_cloud_function/blob/77e841cc9488cf37fb922677f852c44686e0a945/modules/provision_storagefunc/main.tf#L51)) by using:

```
local.vpc_connector_name
```

Key assumptions:
-  `var.region` is a valid GCP locatiom
- There's an existing VPC connector on that region (`var.region`)
- The VPC connector name was already published for general usage by means of `shared_constants` module (pay attention to the combination of specified vars:  `constants_file`, `environment`, `gcs_bucket`, and `region`).

#### Google API enablement requirements

##### Service project

The following APIs will be enabled when a new project is created using the `DevX Landing Zone's project vending`:

- CloudFunctions API: `cloudfunctions.googleapis.com`
- CloudBuild API: `cloudbuild.googleapis.com`
 
 
##### Host project

The following APIs should be enabled for the host networking project:

- Serverless VPC Access API: `vpcaccess.googleapis.com`
- IAM API: `iam.googleapis.com`
- Service Networking API: `servicenetworking.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`


#### IAM roles for the Service Account to be used by the cloud function

It is required to assign the following [IAM roles](https://cloud.google.com/functions/docs/networking/shared-vpc-host-project#make_the_connector_discoverable) to the Service Account that will be used by cloud function in order to work with the Shared VPC network.

Note: If you don't provide a service account as an input, the app engine default SA account will be attached.

##### Service project

- Compute Network Viewer: `roles/compute.networkViewer`

##### Host project (Shared VPC subnet)

- Serverless VPC Access Viewer: `roles/vpcaccess.viewer`


#### IAM roles for the Service Agent

These [IAM roles](https://cloud.google.com/functions/docs/networking/shared-vpc-host-project#provide_access_to_the_connector) should be applied to the Google managed Service Agent that looks like `service-[SERVICE_PROJECT_NUMBER]@gcf-admin-robot.iam.gserviceaccount.com`. Currently, these IAM roles are assigned by the `Shared VPC module in the DevX Landing Zone`:

##### Host project (Shared VPC subnet)

- Serverless VPC Access User: `roles/vpcaccess.user`


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7, < 2.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.52.0, != 4.53.0, < 5.0.0 |

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
