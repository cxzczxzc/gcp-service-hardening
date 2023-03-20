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

  delegated_roles = {
    for index, expression in local.expressions :
    "iam_condition_${index + 1}" => {
      expression = expression
      index      = index + 1
    }
  }
}


resource "google_project_iam_member" "viewer_group_role_assignment" {
  for_each = toset(var.viewer_group_role_assignment)
  project  = var.project_id
  role     = each.value
  member   = var.project_viewer_group
}


resource "google_project_iam_member" "direct_role_assignments" {
  for_each = toset(var.direct_role_grants)
  project  = var.project_id
  role     = each.value
  member   = var.terraform_service_account_for_project
}


resource "google_project_iam_member" "delegated_role_grants" {
  for_each = local.delegated_roles
  project  = var.project_id
  role     = var.restricted_role_grant
  member   = var.terraform_service_account_for_project
  condition {
    title       = "iam_drg_condition_${each.value.index}"
    description = "IAM Conditions for Delegated role grants (${each.value.index}/${length(local.expressions)})."
    expression  = each.value.expression
  }
}


