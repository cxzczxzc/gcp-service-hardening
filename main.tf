resource "google_container_cluster" "test" {
  name               = "terraform-builder-gcs-backend"
  location               = var.region
  initial_node_count = "3"

    # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  node_config {
    disk_size_gb = "10"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      reason = "terraform-builder-example"
    }

    tags = ["example"]
  }
}