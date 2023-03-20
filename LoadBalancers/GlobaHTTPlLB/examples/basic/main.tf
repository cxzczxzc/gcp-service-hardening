# MIG backend for global-lb
resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = "vpc-global-lb-test"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  project       = var.project_id
  region        = "us-east4"
  name          = "sb-east4-global-lb"
  ip_cidr_range = "10.10.10.0/24"
  network       = google_compute_network.default.self_link
}


resource "google_compute_instance_template" "default" {
  project      = var.project_id
  name_prefix  = "instance-template-"
  machine_type = "e2-medium"
  region       = "us-east4"

  // boot disk
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = google_compute_subnetwork.default.name
  }
}


# TODO: Deploy a sample MIG for backend testing
resource "google_compute_instance_group_manager" "default" {
  project = var.project_id
  name    = "test-mig"
  zone    = "us-east4-a"
  named_port {
    name = "http"
    port = 80
  }
  named_port {
    name = "https"
    port = 443
  }
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 1
}


module "gce-lb-http" {
  source = "../.."

  project                         = var.project_id
  name                            = "https-lb"
  managed_ssl_certificate_domains = ["app.test.dnb.net"]
  # ssl_profile = "CUSTOM"
  # ssl_custom_features = ["TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"]
  backends = {
    default = {
      description     = "Test MIG backend group"
      protocol        = "HTTP"
      port            = 80
      port_name       = "http"
      timeout_sec     = 30
      enable_cdn      = false
      security_policy = "projects/${var.project_id}/global/securityPolicies/dnb-sp-cloudarmor-default-policy"

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = google_compute_instance_group_manager.default.instance_group
        }
      ]

      iap_config = {
        enable = false
      }
    }
  }
}

data "google_compute_backend_service" "default" {
  name    = "https-lb-backend-default"
  project = var.project_id
}

data "google_compute_global_forwarding_rule" "default" {
  name    = "https-lb-https"
  project = var.project_id
}