# This file demonstrates using Terraform random provider to generate and store
# a random password as a secret.

resource "google_project_service" "project" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_dependent_services = false
}

module "secret" {
  source      = "../.."
  project_id  = var.project_id
  secret_name = var.secret_name
  replication = var.replication
  secret_data = var.secret_data
  depends_on  = [google_project_service.project]
}



