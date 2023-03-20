
resource "google_compute_forwarding_rule" "default" {
  project               = var.project
  name                  = var.name
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
  allow_global_access   = var.global_access
  load_balancing_scheme = var.load_balancing_scheme
  backend_service       = google_compute_region_backend_service.default.self_link
  ip_address            = var.ip_address
  ip_protocol           = var.ip_protocol
  ports                 = var.ports
  all_ports             = var.all_ports
  service_label         = var.service_label
  labels                = var.labels
}


resource "google_compute_region_backend_service" "default" {
  project = var.project
  name = {
    "tcp"   = "${var.name}",
    "http"  = "${var.name}",
    "https" = "${var.name}",
  }[var.health_check["type"]]
  region                          = var.region
  protocol                        = var.ip_protocol
  network                         = var.network
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  session_affinity                = var.session_affinity
  dynamic "backend" {
    for_each = var.backends
    content {
      group       = lookup(backend.value, "group", null)
      description = lookup(backend.value, "description", null)
      failover    = lookup(backend.value, "failover", null)
    }
  }
  health_checks = concat(google_compute_health_check.tcp.*.self_link, google_compute_health_check.http.*.self_link, google_compute_health_check.https.*.self_link)
}

resource "google_compute_health_check" "tcp" {
  count   = var.health_check["type"] == "tcp" ? 1 : 0
  project = var.project
  name    = "${var.name}-hc-tcp"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  tcp_health_check {
    port         = var.health_check["port"]
    request      = var.health_check["request"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_health_check" "http" {
  count   = var.health_check["type"] == "http" ? 1 : 0
  project = var.project
  name    = "${var.name}-hc-http"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  http_health_check {
    port         = var.health_check["port"]
    request_path = var.health_check["request_path"]
    host         = var.health_check["host"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_health_check" "https" {
  count   = var.health_check["type"] == "https" ? 1 : 0
  project = var.project
  name    = "${var.name}-hc-https"

  timeout_sec         = var.health_check["timeout_sec"]
  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  https_health_check {
    port         = var.health_check["port"]
    request_path = var.health_check["request_path"]
    host         = var.health_check["host"]
    response     = var.health_check["response"]
    port_name    = var.health_check["port_name"]
    proxy_header = var.health_check["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}
