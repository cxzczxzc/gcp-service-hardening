locals {

  all_sa_bindings = merge([for key, binding in var.service_account_bindings :
    { for _, role in binding.roles : "${key}-${role}" =>
      {
        binding_key = key
        principal   = binding.service_account_email
        role        = role
        condition   = lookup(binding, "condition", {})
      }
      if endswith(binding.service_account_email, ".gserviceaccount.com")
    }
  ]...)

  project_id = var.project_id == "" ? data.google_client_config.default.project : var.project_id

}

data "google_client_config" "default" {}

resource "google_project_iam_member" "sa_role_bindings" {
  for_each = local.all_sa_bindings
  project  = local.project_id

  role   = each.value.role
  member = "serviceAccount:${each.value.principal}"

  dynamic "condition" {
    for_each = lookup(each.value, "condition", {}) != null ? [each.value.condition] : []

    content {
      expression  = condition.value.expression
      title       = condition.value.title
      description = condition.value.description
    }
  }
}
