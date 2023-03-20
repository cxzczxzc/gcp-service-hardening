locals {
  zone         = "${var.region}-a"
  test_network = "vpc-l7-ilb-test"
  test_subnet  = "sb-east4-test-l7-ilb"
}

# Test network for testing
resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = local.test_network
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  project       = var.project_id
  region        = var.region
  name          = local.test_subnet
  ip_cidr_range = "10.10.12.0/24"
  network       = google_compute_network.default.self_link
  depends_on = [
    google_compute_subnetwork.proxy-net #to force wait until the subnet gets created.
  ]
}

resource "google_compute_subnetwork" "proxy-net" {
  project       = var.project_id
  region        = var.region
  name          = "${local.test_subnet}-proxy"
  ip_cidr_range = "10.10.13.0/24"
  network       = google_compute_network.default.self_link
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
}

# Deploy a sample MIG for backend testing
resource "google_compute_instance_template" "default" {
  project      = var.project_id
  name_prefix  = "instance-template-"
  machine_type = "e2-medium"
  region       = var.region

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

resource "google_compute_instance_group_manager" "default" {
  project = var.project_id
  name    = "test-mig"
  zone    = local.zone
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

resource "google_compute_instance_group_manager" "mig02" {
  project = var.project_id
  name    = "test-mig02"
  zone    = local.zone
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

module "http_ilb" {
  source     = "../../"
  name       = "internal-lb-https"
  project    = var.project_id
  network    = local.test_network
  region     = var.region
  subnetwork = local.test_subnet

  backends = {
    default = {
      description = "Test MIG backend group"
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 30
      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        { group = google_compute_instance_group_manager.default.instance_group }
      ]

      iap_config = {
        enable = false
      }
    }
    bk-02 = { #Relavent URL map must be provide to support routing to multiple backends.
      description = "Test MIG backend group"
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 30
      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        { group = google_compute_instance_group_manager.mig02.instance_group }
      ]
      iap_config = {
        enable = false
      }
    }
  }
  certificate = tls_self_signed_cert.cert.cert_pem
  private_key = tls_private_key.key.private_key_pem

  depends_on = [
    google_compute_instance_group_manager.default
  ]
}

# Test certs
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "cert" {
  private_key_pem = tls_private_key.key.private_key_pem

  subject {
    common_name  = "*.app.example.com"
    organization = "Test only cert"
  }

  validity_period_hours = 1

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
