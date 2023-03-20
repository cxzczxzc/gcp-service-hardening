
resource "google_project_iam_member" "dap_exception_group_role_assignment" {
  for_each = toset(var.exception_roles)
  project  = var.project_id
  role     = each.value
  member   = var.exception_group
}
