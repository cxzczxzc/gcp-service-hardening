locals {
  zone         = "${var.region}-a"
  test_network = "vpc-ilb-test"
  test_subnet  = "sb-east4-test-ilb"
}

# Test network for testing
resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = local.test_network
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  project       = var.project_id
  region        = "us-east4"
  name          = local.test_subnet
  ip_cidr_range = "10.10.10.0/24"
  network       = google_compute_network.default.self_link
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
  name    = "test-mig-l4"
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
  name    = "test-mig-l402"
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

# TCP ILB
module "tcp_ilb" {
  source      = "../.."
  project     = var.project_id
  network     = local.test_network
  subnetwork  = local.test_subnet
  region      = var.region
  name        = "internal-lb-tcp"
  ip_protocol = "TCP"
  ports       = ["80"]
  backends = [
    { group = google_compute_instance_group_manager.default.instance_group, description = "MIG backend primary", failover = false },
    { group = google_compute_instance_group_manager.mig02.instance_group, description = "MIG backend 02", failover = false },
  ]
  health_check = {
    request_path = "/"
    port         = 80
    enable_log   = true
    type         = "http"
  }
}
