# terraform-google-dnb_gcp_cloud_composer

Module to create gcp cloud composer-v2 environment.

# Deploying composer in PSC mode
Composer defaults to using VPC peering for connecting to DnB's GCP VPC, and VPC peerings are limited per network. Hence composers are enforced to be deployed in a PSC mode, which will replace the underlying peering with PSC endpoint. Please refer to the details in [Private IP with PSC](https://cloud.google.com/composer/docs/composer-2/environment-architecture#private-ip-psc) section for context.

As a result composer PSC endpoints are defaults to Composer pimary node subnet, but it can be overridden by explicitly defining `cloud_composer_connection_subnetwork` variable, and the variable requires a full path to the subnet. ex: `"projects/${var.network_project_id}/regions/${var.region}/subnetworks/${var.composer_subnetwork}"` 


# Usage
## Managing egressnatpolicy or noSNAT functionality
Composer deployment manages and autopilot cluster for which teams are expected to configure egressnatpolcies explicitly outside of the composer module post cluster creation. Please follow the below instructions to conigure egressnatpolcies.  

Below config needs to be applied only on a cluster recreate. However, below config needs to be managed outside of your root module managing the composer cluster and intended to be executed post Composer/GKE cluster creation explicitly by the user as a seperate process. Either of the below options can be choosen as applicable.

### terraform code reference
Using the official [kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) from hashicorp.

```hcl
data "google_client_config" "provider" {}

provider "kubernetes" {
  host                   = "gke_private_endpoint"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(gke_cluster_ca_certificate)
  experiments {
    manifest_resource = true
  }
}

resource "kubernetes_manifest" "egressnatpolicies_default" {
  manifest = {
    apiVersion = "v1"
   "kind" = "EgressNATPolicy"
    "metadata" = {
      "name" = "default"
    }
   "spec" = {
      "action" = "NoSNAT"
      "destinations" = ["10.116.0.0/14", "100.64.0.0/11"]
   }
  }
}
```

Using the [gavinbunney/kubectl](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs) provider

```hcl
data "google_client_config" "provider" {}

provider "kubectl" {
  load_config_file = false
  host                   = "gke_private_endpoint"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(gke_cluster_ca_certificate)
}

resource "kubectl_manifest" "egressnatpolicies_default" {
  yaml_body  = <<YAML
    apiVersion: networking.gke.io/v1
    kind: EgressNATPolicy
    metadata:
      name: default
    spec:
      action: NoSNAT
      destinations:
      - cidr:  "10.116.0.0/14"
      - cidr:  "100.64.0.0/11"
    YAML
}
```

gcloud and kubectl references

```bash
gcloud container clusters get-credentials <name-of-the-cluster>

cat <<EOF | kubectl apply -f -
apiVersion: networking.gke.io/v1
kind: EgressNATPolicy
metadata:
  name: default
spec:
  action: NoSNAT
  destinations:
  - cidr: "10.116.0.0/14"
  - cidr: "100.64.0.0/11"
EOF
```

destination IPs should match the IPs in [constants module](https://github.com/dnb-main/terraform-google-dnb_gcp_shared_constants/blob/fe5cb5605604d386571ebe4c0fb0c0596f99513b/main.tf#L49-L58).

This config can be managed in the composer module native when either of the below issues are addressed:
1. https://github.com/hashicorp/terraform-provider-kubernetes/issues/1391
2. https://github.com/hashicorp/terraform/issues/2430
3. Issue with gavinbunney/kubectl 3rd party provider with init on a Composer/GKE cluster recreate(similar to [this report](https://github.com/gavinbunney/terraform-provider-kubectl/issues/228)).

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

### Prerequisties for Using
Currently, there's a regex pattern which determines which projects will have composer API and permissions enabled. The regex needs to be updated in two places:
- Project Module (API enablement): https://github.com/dnb-main/terraform-google-dnb_gcp_project/blob/43814d6e6a0357463bac408880bd81dff02716b3/variables.tf#L14
- shared_vpc module:https://github.com/dnb-main/terraform-google-dnb_gcp_shared_vpc/blob/2e5764196b9b2aaef37f79643388875ec286473f/variables.tf#L122

This method of enablement will be superseded by: https://jira.aws.dnb.com/browse/DEEP-725

The following Firewall rules need to be configured in the shared VPC 

Configure the following firewall rules:

Allow egress from GKE Node IP range to any destination (0.0.0.0/0), TCP/UDP port 53, or if you know DNS server IP addresses, then allow egress from GKE Node IP range to DNS IP addresses over TCP/UDP port 53.
Allow ingress and egress traffic between GKE Node IP range and GKE Node IP range, all ports.
Allow ingress and egress traffic between GKE Node IP range and Pods IP range, all ports.
Allow ingress and egress traffic between GKE Node IP range and Services IP range, all ports.
Allow ingress and egress traffic between GKE Pods and Services IP ranges, all ports.
Allow ingress and egress from GKE Node IP range to GKE Control Plane IP range, all ports.
Allow ingress from GCP Health Checks 130.211.0.0/22, 35.191.0.0/16 to GKE Node IP range, TCP ports 80 and 443.
Allow egress from GKE Node IP range to GCP Health Checks 130.211.0.0/22, 35.191.0.0/16, TCP ports 80 and 443.
Allow egress from GKE Node IP range to Web server IP range, TCP ports 3306 and 3307.

Confluence Page:  https://confluence.aws.dnb.com/display/DACOE/Shared+VPC+configuration+for+cloud+composer

## Contributing


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.27.0, <5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.27.0, <5.0 |
| <a name="requirement_infoblox"></a> [infoblox](#requirement\_infoblox) | 2.1.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.27.0, <5.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.27.0, <5.0 |
| <a name="provider_infoblox"></a> [infoblox](#provider\_infoblox) | 2.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_composer"></a> [composer](#module\_composer) | terraform-google-modules/composer/google//modules/create_environment_v2 | ~> 3.3.0 |
| <a name="module_dnb_gcp_shared_constants"></a> [dnb\_gcp\_shared\_constants](#module\_dnb\_gcp\_shared\_constants) | app.terraform.io/dnb-core/dnb_gcp_shared_constants/google | 1.6.0 |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | terraform-google-modules/service-accounts/google | ~> 4.1 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_project_service_identity.composer_agent](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_project_service_identity) | resource |
| [google_service_account_iam_member.composer_agent_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [infoblox_ipv4_network.cloud_composer_cidr](https://registry.terraform.io/providers/infobloxopen/infoblox/2.1.0/docs/resources/ipv4_network) | resource |
| [google_compute_subnetwork.my-subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_network_tags"></a> [additional\_network\_tags](#input\_additional\_network\_tags) | The network tags in the cloud composer environment. | `list(any)` | `[]` | no |
| <a name="input_airflow_config_overrides"></a> [airflow\_config\_overrides](#input\_airflow\_config\_overrides) | Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example "core-dags\_are\_paused\_at\_creation". | `map(string)` | `{}` | no |
| <a name="input_cloud_composer_connection_subnetwork"></a> [cloud\_composer\_connection\_subnetwork](#input\_cloud\_composer\_connection\_subnetwork) | Subnet for PSC endpoint. Refer to the conditional logic in main.tf, this defaults to node subnet. See: https://cloud.google.com/composer/docs/composer-2/environment-architecture#private-ip-psc | `string` | `null` | no |
| <a name="input_cloud_composer_network_ipv4_cidr_block"></a> [cloud\_composer\_network\_ipv4\_cidr\_block](#input\_cloud\_composer\_network\_ipv4\_cidr\_block) | The CIDR block from which IP range in tenant project will be reserved. | `string` | `null` | no |
| <a name="input_cloud_sql_ipv4_cidr"></a> [cloud\_sql\_ipv4\_cidr](#input\_cloud\_sql\_ipv4\_cidr) | The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. | `string` | `null` | no |
| <a name="input_composer_env_name"></a> [composer\_env\_name](#input\_composer\_env\_name) | Name of Cloud Composer Environment | `string` | n/a | yes |
| <a name="input_enable_ip_masq_agent"></a> [enable\_ip\_masq\_agent](#input\_enable\_ip\_masq\_agent) | Deploys 'ip-masq-agent' daemon set in the GKE cluster and defines nonMasqueradeCIDRs equals to pod IP range so IP masquerading is used for all destination addresses, except between pods traffic. | `bool` | `false` | no |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | Variables of the airflow environment. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Application environment stage | `string` | `"non_prod"` | no |
| <a name="input_environment_size"></a> [environment\_size](#input\_environment\_size) | The environment size controls the performance parameters of the managed Cloud Composer infrastructure that includes the Airflow database. Values for environment size are ENVIRONMENT\_SIZE\_SMALL, ENVIRONMENT\_SIZE\_MEDIUM, and ENVIRONMENT\_SIZE\_LARGE | `string` | n/a | yes |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The version of the aiflow running in the cloud composer environment. | `string` | `"composer-2.0.2-airflow-2.1.4"` | no |
| <a name="input_network"></a> [network](#input\_network) | Network where Cloud Composer is created. | `string` | n/a | yes |
| <a name="input_network_project_id"></a> [network\_project\_id](#input\_network\_project\_id) | The project ID of the shared VPC's host (for shared vpc support) | `string` | n/a | yes |
| <a name="input_pod_ip_allocation_range_name"></a> [pod\_ip\_allocation\_range\_name](#input\_pod\_ip\_allocation\_range\_name) | The name of the cluster's secondary range used to allocate IP addresses to pods. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID where Cloud Composer Environment is created. | `string` | n/a | yes |
| <a name="input_pypi_packages"></a> [pypi\_packages](#input\_pypi\_packages) | Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. "numpy"). | `map(string)` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the Cloud Composer Environment is created. | `string` | `"us-central1"` | no |
| <a name="input_scheduler"></a> [scheduler](#input\_scheduler) | Configuration for resources used by Airflow schedulers. | <pre>object({<br>    cpu        = string<br>    memory_gb  = number<br>    storage_gb = number<br>    count      = number<br>  })</pre> | <pre>{<br>  "count": 2,<br>  "cpu": 2,<br>  "memory_gb": 7.5,<br>  "storage_gb": 10<br>}</pre> | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Service Account to be used for running Cloud Composer Environment. | `string` | n/a | yes |
| <a name="input_service_ip_allocation_range_name"></a> [service\_ip\_allocation\_range\_name](#input\_service\_ip\_allocation\_range\_name) | The name of the services' secondary range used to allocate IP addresses to the cluster. | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Subetwork where Cloud Composer is created. | `string` | n/a | yes |
| <a name="input_web_server"></a> [web\_server](#input\_web\_server) | Configuration for resources used by Airflow web server. | <pre>object({<br>    cpu        = string<br>    memory_gb  = number<br>    storage_gb = number<br>  })</pre> | <pre>{<br>  "cpu": 2,<br>  "memory_gb": 7.5,<br>  "storage_gb": 10<br>}</pre> | no |
| <a name="input_worker"></a> [worker](#input\_worker) | Configuration for resources used by Airflow workers. | <pre>object({<br>    cpu        = string<br>    memory_gb  = number<br>    storage_gb = number<br>    min_count  = number<br>    max_count  = number<br>  })</pre> | <pre>{<br>  "cpu": 2,<br>  "max_count": 6,<br>  "memory_gb": 7.5,<br>  "min_count": 2,<br>  "storage_gb": 10<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_airflow_uri"></a> [airflow\_uri](#output\_airflow\_uri) | URI of the Apache Airflow Web UI hosted within the Cloud Composer Environment. |
| <a name="output_composer_env_id"></a> [composer\_env\_id](#output\_composer\_env\_id) | ID of Cloud Composer Environment. |
| <a name="output_composer_env_name"></a> [composer\_env\_name](#output\_composer\_env\_name) | Name of the Cloud Composer Environment. |
| <a name="output_gcs_bucket"></a> [gcs\_bucket](#output\_gcs\_bucket) | Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment. |
| <a name="output_gke_cluster"></a> [gke\_cluster](#output\_gke\_cluster) | Google Kubernetes Engine cluster used to run the Cloud Composer Environment. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
