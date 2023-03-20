# Summary
This module solves the problem of having an over provisioned project level Terrform Service Account. It is the implementation of the design for incorporating principle of least privilege at DnB. 

## Relevant ADRs - with comments from Google team
- [ADR-027-Ensure that ServiceAccount has no Admin privileges](https://github.com/dnb-main/deep-devxplatform-docs/blob/main/docs/ADRs/ADR-027-Ensure%20that%20ServiceAccount%20has%20no%20Admin%20privileges.md)
- [ADR-028-Ensure that separation of duties (SoD)](https://github.com/dnb-main/deep-devxplatform-docs/blob/main/docs/ADRs/ADR-028-Ensure%20that%20separation%20of%20duties%20(SoD).md)
  - **Comment:** This solution achieves the requirements in this ADR scoped at the project level. By design, it is currently not possible/feasible to apply this ADR at levels above the Project level, such as Folder or Organization. 
 Additionally, `roles/iam.serviceAccountAdmin` and `roles/iam.serviceAccountUser` can be removed from the IAM condition to fulfill this ADR's requirement. The roles are currently allowed in the IAM condition.
- [ADR-029-Minimize the Use of Primitive Roles](https://github.com/dnb-main/deep-devxplatform-docs/blob/main/docs/ADRs/ADR-029-Minimize%20the%20Use%20of%20Primitive%20Roles.md)
  - **Comment:** This solution makes it technically possible to achieve the objective of the ADR. But, the ADR has a list of exception cases where it might be okay to bypass the requirements. A process needs to be built by DnB around granting those exceptions.
- [ADR-031-Ensure that IAM users are not assigned Service Account User role at project level](https://github.com/dnb-main/deep-devxplatform-docs/blob/main/docs/ADRs/ADR-031-Ensure%20that%20IAM%20users%20are%20not%20assigned%20Service%20Account%20User%20role%20at%20project%20level.md)
  - **Comment:**  `roles/iam.serviceAccountAdmin` and `roles/iam.serviceAccountUser` can be removed from the IAM condition to fulfill this ADR's requirement. The roles are currently allowed in the IAM condition. 


# Description 

This solution is designed to achieve what the above ADRs describe, as well as to move towards DnB's goal of implementing principle of least privilege in their organization. Currently the project level service account is deployed with the `Owner` role. There are additional requirements from the ADRs that are fulfilled by this module as well. 

This solution was decided and finalized after a long discussion about the approach. The alternatives can be provided if needed but are not listed here for the sake of brevity. 

In addition to the above, this module also takes into account preventing users accessing their projects through the console to perform work. Thus, the viewer group for the project gets assigned a set of roles that ensure that console access is read-only. 

# How it works
This solution uses IAM conditions to restrict users to grant themselves excessive permissions.

The module would work as follows:
* The DevX Project Vending Service account receives a request to create a project, and it deploys the following resources (or more depending on use case):
 - GCP Project
 - Terraform Cloud Service Account
 - VPC Network with at least 1 subnet
 - APIs enabled based on service selection
* The `Terraform Cloud Service Account` from step 1 is project level service account. This account is used for granting roles to project level identities, so that they can access their required resources. The list of roles that can be granted, however, is restriced. This restriction is enforced in code, by an IAM condition. This service account itself has `roles/resourcemanager.projectIamAdmin` and other admin roles for approved services, which can be found in `variables.tf` file.
* The viewer group : `devx-gcp-iam-role-proj_viewer-{PROJECTID}@dnb.com` gets read-only roles assigned to it. This would enable users to view services through the console but restrict the ability to perform any CRUD operations. An exception to this is BigQuery, for which additional roles are provisioned in order to ensure operability through the console.  
* Users use the Terraform Cloud Workspace, which is authenticated and authorized to the GCP Project by the `Terraform Cloud Service Account` to control IAM for resources.


## Technical Details about the DRG IAM condition

IAM conditions use a CEL (Common Expression Language) expression syntax to build IAM conditions. 

```
api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly([%s])
```
The `%s` is replaced by a list of roles. There is a limit of 10 roles allowed per `.hasOnly()` call. Additionally, 13 calls to the above expression can be made and concatenated with `||` in a single IAM condition. So effectively, the limit is 130 roles per IAM resource binding. 

This module works around that by applying the IAM admin binding in multiple bindings of 130 roles. 

The code snippet below shows the behavior in more detail

```terraform
locals {
  roles = formatlist("'%s'", sort(var.delegated_role_grants))
  role_chunks = [
    for chunk in chunklist(local.roles, 10) :
    join(", ", chunk)
  ]
  condition_string = "api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly([%s])"
  conditions       = formatlist(local.condition_string, local.role_chunks)
  expressions = [
    for chunk in chunklist(local.conditions, 13) :
    join(" || ", chunk)
  ]

  iam_bindings = {
    for index, expression in local.expressions :
    "iam_condition_${index + 1}" => {
      expression = expression
      index      = index + 1
    }
  }
}
```

1. Start with the list of roles to apply
2. Divide up roles into chunks of 10
3. Each chunk of 10 is used to create a condition_string in the format of `"api.getAttribute('iam.googleapis.com/modifiedGrantsByRole', []).hasOnly([%s])"`
4. Collect up to 13 condition strings per binding -> i.e. effective limit of 130 roles per IAM binding
5. Create IAM binding for each set of 130 roles


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
| [google_project_iam_member.delegated_role_grants](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.direct_role_assignments](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.viewer_group_role_assignment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delegated_role_grants"></a> [delegated\_role\_grants](#input\_delegated\_role\_grants) | List of roles that project administrators will be allowed to grant/revoke. | `list(string)` | <pre>[<br>  "roles/artifactregistry.reader",<br>  "roles/artifactregistry.repoAdmin",<br>  "roles/artifactregistry.writer",<br>  "roles/bigquery.connectionUser",<br>  "roles/bigquery.dataEditor",<br>  "roles/bigquery.dataViewer",<br>  "roles/bigquery.filteredDataViewer",<br>  "roles/bigquery.jobUser",<br>  "roles/bigquery.metadataViewer",<br>  "roles/bigquery.readSessionUser",<br>  "roles/bigquery.resourceAdmin",<br>  "roles/bigquery.resourceEditor",<br>  "roles/bigquery.resourceViewer",<br>  "roles/bigquery.user",<br>  "roles/bigquerydatapolicy.maskedReader",<br>  "roles/bigquerymigration.editor",<br>  "roles/bigquerymigration.orchestrator",<br>  "roles/bigquerymigration.translationUser",<br>  "roles/bigquerymigration.viewer",<br>  "roles/bigquerymigration.worker",<br>  "roles/cloudfunctions.developer",<br>  "roles/cloudfunctions.invoker",<br>  "roles/cloudfunctions.viewer",<br>  "roles/cloudkms.cryptoKeyDecrypter",<br>  "roles/cloudkms.cryptoKeyDecrypterViaDelegation",<br>  "roles/cloudkms.cryptoKeyEncrypter",<br>  "roles/cloudkms.cryptoKeyEncrypterDecrypter",<br>  "roles/cloudkms.cryptoKeyEncrypterDecrypterViaDelegation",<br>  "roles/cloudkms.cryptoKeyEncrypterViaDelegation",<br>  "roles/cloudkms.cryptoOperator",<br>  "roles/cloudkms.expertRawPKCS1",<br>  "roles/cloudkms.importer",<br>  "roles/cloudkms.publicKeyViewer",<br>  "roles/cloudkms.signer",<br>  "roles/cloudkms.signerVerifier",<br>  "roles/cloudkms.verifier",<br>  "roles/cloudkms.viewer",<br>  "roles/cloudsql.admin",<br>  "roles/cloudsql.client",<br>  "roles/cloudsql.editor",<br>  "roles/cloudsql.instanceUser",<br>  "roles/cloudsql.viewer",<br>  "roles/composer.environmentAndStorageObjectViewer",<br>  "roles/compute.imageUser",<br>  "roles/compute.loadBalancerServiceUser",<br>  "roles/compute.osAdminLogin",<br>  "roles/compute.osLogin",<br>  "roles/compute.publicIpAdmin",<br>  "roles/compute.soleTenantViewer",<br>  "roles/compute.viewer",<br>  "roles/container.admin",<br>  "roles/container.clusterAdmin",<br>  "roles/container.clusterViewer",<br>  "roles/container.developer",<br>  "roles/container.viewer",<br>  "roles/containeranalysis.notes.attacher",<br>  "roles/containeranalysis.notes.editor",<br>  "roles/containeranalysis.notes.occurrences.viewer",<br>  "roles/containeranalysis.notes.viewer",<br>  "roles/containeranalysis.occurrences.editor",<br>  "roles/containeranalysis.occurrences.viewer",<br>  "roles/containersecurity.viewer",<br>  "roles/datacatalog.categoryFineGrainedReader",<br>  "roles/datacatalog.entryGroupCreator",<br>  "roles/datacatalog.entryViewer",<br>  "roles/datacatalog.tagEditor",<br>  "roles/datacatalog.tagTemplateCreator",<br>  "roles/datacatalog.tagTemplateUser",<br>  "roles/datacatalog.tagTemplateViewer",<br>  "roles/datacatalog.viewer",<br>  "roles/dataproc.editor",<br>  "roles/dataproc.hubAgent",<br>  "roles/dataproc.viewer",<br>  "roles/gkebackup.delegatedBackupAdmin",<br>  "roles/gkebackup.delegatedRestoreAdmin",<br>  "roles/gkebackup.viewer",<br>  "roles/gkehub.connect",<br>  "roles/gkehub.editor",<br>  "roles/gkehub.gatewayReader",<br>  "roles/gkehub.viewer",<br>  "roles/gkemulticloud.admin",<br>  "roles/gkemulticloud.telemetryWriter",<br>  "roles/gkemulticloud.viewer",<br>  "roles/gkeonprem.viewer",<br>  "roles/iam.securityReviewer",<br>  "roles/iam.serviceAccountTokenCreator",<br>  "roles/iam.serviceAccountCreator",<br>  "roles/iam.serviceAccountUser",<br>  "roles/iam.serviceAccountViewer",<br>  "roles/logging.admin",<br>  "roles/logging.bucketWriter",<br>  "roles/logging.configWriter",<br>  "roles/logging.fieldAccessor",<br>  "roles/logging.logWriter",<br>  "roles/logging.privateLogViewer",<br>  "roles/logging.viewAccessor",<br>  "roles/logging.viewer",<br>  "roles/monitoring.admin",<br>  "roles/monitoring.alertPolicyEditor",<br>  "roles/monitoring.alertPolicyViewer",<br>  "roles/monitoring.dashboardEditor",<br>  "roles/monitoring.dashboardViewer",<br>  "roles/monitoring.editor",<br>  "roles/monitoring.metricsScopesAdmin",<br>  "roles/monitoring.metricsScopesViewer",<br>  "roles/monitoring.metricWriter",<br>  "roles/monitoring.notificationChannelEditor",<br>  "roles/monitoring.notificationChannelViewer",<br>  "roles/monitoring.servicesEditor",<br>  "roles/monitoring.servicesViewer",<br>  "roles/monitoring.uptimeCheckConfigEditor",<br>  "roles/monitoring.uptimeCheckConfigViewer",<br>  "roles/monitoring.viewer",<br>  "roles/osconfig.instanceOSPoliciesComplianceViewer",<br>  "roles/osconfig.inventoryViewer",<br>  "roles/osconfig.osPolicyAssignmentAdmin",<br>  "roles/osconfig.osPolicyAssignmentEditor",<br>  "roles/osconfig.osPolicyAssignmentReportViewer",<br>  "roles/osconfig.osPolicyAssignmentViewer",<br>  "roles/osconfig.patchDeploymentAdmin",<br>  "roles/osconfig.patchDeploymentViewer",<br>  "roles/osconfig.patchJobExecutor",<br>  "roles/osconfig.patchJobViewer",<br>  "roles/osconfig.vulnerabilityReportViewer",<br>  "roles/pubsub.editor",<br>  "roles/pubsub.admin",<br>  "roles/pubsub.publisher",<br>  "roles/pubsub.subscriber",<br>  "roles/pubsub.viewer",<br>  "roles/secretmanager.secretAccessor",<br>  "roles/secretmanager.secretVersionAdder",<br>  "roles/secretmanager.secretVersionManager",<br>  "roles/secretmanager.viewer",<br>  "roles/storage.objectAdmin",<br>  "roles/storage.objectCreator",<br>  "roles/storage.objectViewer",<br>  "roles/storagetransfer.admin",<br>  "roles/storagetransfer.transferAgent",<br>  "roles/storagetransfer.user",<br>  "roles/storagetransfer.viewer"<br>]</pre> | no |
| <a name="input_direct_role_grants"></a> [direct\_role\_grants](#input\_direct\_role\_grants) | List of roles granted directly to project administrators. | `list(string)` | <pre>[<br>  "roles/artifactregistry.admin",<br>  "roles/bigquery.admin",<br>  "roles/bigquery.admin",<br>  "roles/composer.admin",<br>  "roles/composer.worker",<br>  "roles/cloudfunctions.admin",<br>  "roles/cloudkms.admin",<br>  "roles/cloudkms.cryptoKeyDecrypter",<br>  "roles/cloudkms.verifier",<br>  "roles/cloudkms.cryptoOperator",<br>  "roles/cloudkms.importer",<br>  "roles/cloudkms.cryptoKeyEncrypterViaDelegation",<br>  "roles/cloudkms.expertRawPKCS1",<br>  "roles/cloudkms.signer",<br>  "roles/cloudkms.cryptoKeyDecrypterViaDelegation",<br>  "roles/cloudkms.cryptoKeyEncrypter",<br>  "roles/cloudkms.cryptoKeyEncrypterDecrypter",<br>  "roles/cloudkms.signerVerifier",<br>  "roles/cloudkms.cryptoKeyEncrypterDecrypterViaDelegation",<br>  "roles/cloudkms.publicKeyViewer",<br>  "roles/cloudsql.admin",<br>  "roles/storage.admin",<br>  "roles/storagetransfer.admin",<br>  "roles/containeranalysis.admin",<br>  "roles/datacatalog.admin",<br>  "roles/dataproc.admin",<br>  "roles/compute.admin",<br>  "roles/container.admin",<br>  "roles/gkebackup.admin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/iam.serviceAccountCreator",<br>  "roles/iam.serviceAccountDeleter",<br>  "roles/iam.serviceAccountUser",<br>  "roles/logging.admin",<br>  "roles/monitoring.admin",<br>  "roles/pubsub.admin",<br>  "roles/secretmanager.admin"<br>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id where to grant direct and delegated roles to the users listed in project\_administrators. | `string` | n/a | yes |
| <a name="input_project_viewer_group"></a> [project\_viewer\_group](#input\_project\_viewer\_group) | The project level viewer group that would be assigned read-only privileges (with a few exceptions like BQ) | `string` | n/a | yes |
| <a name="input_restricted_role_grant"></a> [restricted\_role\_grant](#input\_restricted\_role\_grant) | Role that will be granted to the project level terraform service account | `string` | `"roles/resourcemanager.projectIamAdmin"` | no |
| <a name="input_terraform_service_account_for_project"></a> [terraform\_service\_account\_for\_project](#input\_terraform\_service\_account\_for\_project) | The service account that will be granted administrator permissions at the project level. | `string` | n/a | yes |
| <a name="input_viewer_group_role_assignment"></a> [viewer\_group\_role\_assignment](#input\_viewer\_group\_role\_assignment) | List of roles assigned to the viewer group at the project level | `list(string)` | <pre>[<br>  "roles/bigquery.connectionUser",<br>  "roles/bigquery.dataEditor",<br>  "roles/bigquery.dataViewer",<br>  "roles/bigquery.filteredDataViewer",<br>  "roles/bigquery.jobUser",<br>  "roles/bigquery.metadataViewer",<br>  "roles/bigquery.readSessionUser",<br>  "roles/bigquery.resourceEditor",<br>  "roles/bigquery.resourceViewer",<br>  "roles/bigquery.user",<br>  "roles/bigquerydatapolicy.maskedReader",<br>  "roles/bigquerymigration.editor",<br>  "roles/bigquerymigration.orchestrator",<br>  "roles/bigquerymigration.translationUser",<br>  "roles/bigquerymigration.viewer",<br>  "roles/bigquerymigration.worker",<br>  "roles/artifactregistry.reader",<br>  "roles/cloudfunctions.viewer",<br>  "roles/cloudfunctions.invoker",<br>  "roles/cloudkms.viewer",<br>  "roles/cloudsql.instanceUser",<br>  "roles/cloudsql.viewer",<br>  "roles/composer.environmentAndStorageObjectViewer",<br>  "roles/compute.viewer",<br>  "roles/container.clusterViewer",<br>  "roles/container.viewer",<br>  "roles/containersecurity.viewer",<br>  "roles/containeranalysis.occurrences.viewer",<br>  "roles/containeranalysis.notes.viewer",<br>  "roles/containeranalysis.notes.occurrences.viewer",<br>  "roles/datacatalog.entryViewer",<br>  "roles/datacatalog.viewer",<br>  "roles/dataproc.viewer",<br>  "roles/gkebackup.viewer",<br>  "roles/gkehub.viewer",<br>  "roles/gkehub.gatewayReader",<br>  "roles/gkemulticloud.viewer",<br>  "roles/gkeonprem.viewer",<br>  "roles/iam.serviceAccountViewer",<br>  "roles/logging.privateLogViewer",<br>  "roles/logging.viewer",<br>  "roles/monitoring.alertPolicyViewer",<br>  "roles/monitoring.dashboardViewer",<br>  "roles/monitoring.metricsScopesViewer",<br>  "roles/monitoring.notificationChannelViewer",<br>  "roles/monitoring.servicesViewer",<br>  "roles/monitoring.uptimeCheckConfigViewer",<br>  "roles/osconfig.instanceOSPoliciesComplianceViewer",<br>  "roles/osconfig.inventoryViewer",<br>  "roles/osconfig.osPolicyAssignmentReportViewer",<br>  "roles/osconfig.osPolicyAssignmentViewer",<br>  "roles/osconfig.patchDeploymentViewer",<br>  "roles/osconfig.patchJobViewer",<br>  "roles/osconfig.vulnerabilityReportViewer",<br>  "roles/pubsub.viewer",<br>  "roles/secretmanager.viewer",<br>  "roles/storage.objectViewer",<br>  "roles/storagetransfer.viewer"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delegated_roles"></a> [delegated\_roles](#output\_delegated\_roles) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
