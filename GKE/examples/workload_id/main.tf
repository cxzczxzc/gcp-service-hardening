locals {
  k8s_namespace = "test"
  k8s_sa_name   = "test"
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

## Create Google SA and give k8s service account from workload pool workloadIdentityUser on the google SA

resource "google_service_account" "workload-id-google-sa" {
  account_id   = "cluster-viewer"
  display_name = "Service account used for Workload ID for SQL access"
}

resource "google_service_account_iam_member" "k8s_sa_user" {
  service_account_id = google_service_account.workload-id-google-sa.name

  role   = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${module.private_gke.identity_namespace}[${local.k8s_namespace}/${local.k8s_sa_name}]" # k8s service account with [<namespace>/<app>]
}

## bind roles you want to use from k8s to your SA

resource "google_project_iam_member" "gke_wlid_viewer" {
  project = data.google_client_config.default.project

  role = "roles/container.clusterViewer"

  member = "serviceAccount:${google_service_account.workload-id-google-sa.email}"
}

resource "time_sleep" "wait_for_cluster_startup" {
  depends_on = [
    module.private_gke,
    google_service_account_iam_member.k8s_sa_user
  ]

  create_duration = "2m"
}

## kubernetes ns, service account, and job that demonstrates workload identity in practice

resource "kubernetes_namespace" "workload_id_ns" {
  metadata {
    name = local.k8s_namespace
  }

  depends_on = [
    module.private_gke,
    time_sleep.wait_for_cluster_startup
  ]
}

resource "kubernetes_service_account" "workload-id-k8s-sa" {
  metadata {
    name = local.k8s_sa_name
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.workload-id-google-sa.email
    }
    namespace = local.k8s_namespace
  }

  depends_on = [
    module.private_gke,
    kubernetes_namespace.workload_id_ns,
    time_sleep.wait_for_cluster_startup
  ]
}

# This job uses the gcloud cli to list all clusters in the current project. It will successfully complete if workload identity is enabled
# If workload identity fails, the job will enter an errored state

resource "kubernetes_job" "demo" {
  metadata {
    name      = "demo"
    namespace = local.k8s_namespace
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "gcloud"
          image   = "gcr.io/google.com/cloudsdktool/google-cloud-cli:latest"
          command = ["gcloud", "container", "clusters", "list"]
        }
        restart_policy       = "Never"
        service_account_name = local.k8s_sa_name
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true
  timeouts {
    create = "5m"
  }

  depends_on = [
    kubernetes_service_account.workload-id-k8s-sa,
    time_sleep.wait_for_cluster_startup
  ]
}
