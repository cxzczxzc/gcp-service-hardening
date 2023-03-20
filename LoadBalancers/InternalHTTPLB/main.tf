locals {
  create_http_forward     = var.http_forward || var.https_redirect
  url_map                 = var.create_url_map ? join("", google_compute_region_url_map.default.*.self_link) : var.url_map
  address                 = var.create_address ? join("", google_compute_address.default.*.address) : var.address
  health_checked_backends = { for backend_index, backend_value in var.backends : backend_index => backend_value if backend_value["health_check"] != null }
}

# To support sharedVPC use-cases.
data "google_compute_network" "network" {
  name    = var.network
  project = var.network_project == "" ? var.project : var.network_project
}

data "google_compute_subnetwork" "subnet" {
  name    = var.subnetwork
  project = var.network_project == "" ? var.project : var.network_project
  region  = var.region
}

// Forwarding rule for Internal Load Balancing
resource "google_compute_forwarding_rule" "http" {
  count                 = local.create_http_forward ? 1 : 0
  project               = var.project
  name                  = "${var.name}-http"
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default[0].self_link
  network               = data.google_compute_network.network.self_link
  subnetwork            = data.google_compute_subnetwork.subnet.self_link
  ip_address            = local.address
  labels                = var.labels
}

resource "google_compute_forwarding_rule" "https" {
  project               = var.project
  count                 = var.ssl ? 1 : 0
  name                  = "${var.name}-https"
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_region_target_https_proxy.default[0].self_link
  network               = data.google_compute_network.network.self_link
  subnetwork            = data.google_compute_subnetwork.subnet.self_link
  ip_address            = local.address
  labels                = var.labels
}

resource "google_compute_address" "default" {
  provider     = google-beta
  count        = var.create_address ? 1 : 0
  project      = var.project
  subnetwork   = data.google_compute_subnetwork.subnet.id
  region       = var.region
  address_type = "INTERNAL"
  purpose      = "SHARED_LOADBALANCER_VIP"
  name         = "${var.name}-address"
  labels       = var.labels
}

resource "google_compute_region_target_http_proxy" "default" {
  count   = local.create_http_forward ? 1 : 0
  project = var.project
  region  = var.region
  name    = "${var.name}-http-proxy"
  url_map = var.https_redirect == false ? local.url_map : join("", google_compute_region_url_map.https_redirect.*.self_link)
}

# HTTPS proxy when ssl is true
resource "google_compute_region_target_https_proxy" "default" {
  provider         = google-beta
  project          = var.project
  region           = var.region
  count            = var.ssl ? 1 : 0
  name             = "${var.name}-https-proxy"
  url_map          = local.url_map
  ssl_certificates = compact(concat(var.ssl_certificates, google_compute_region_ssl_certificate.default.*.self_link), )
  ssl_policy       = var.ssl_policy == null ? google_compute_region_ssl_policy.dnb-ssl-policy.id : var.ssl_policy
}

# DnB's default SSL policy
resource "google_compute_region_ssl_policy" "dnb-ssl-policy" {
  project         = var.project
  provider        = google-beta
  region          = var.region
  name            = "dnb-ssl-policy"
  min_tls_version = "TLS_1_2"
  profile         = var.ssl_profile == "CUSTOM" ? "CUSTOM" : "MODERN" #only ECDHE ciphers are allowed in MODERN profile. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy
  custom_features = var.ssl_profile == "CUSTOM" ? var.ssl_custom_features : []
}

resource "google_compute_region_ssl_certificate" "default" {
  project     = var.project
  count       = var.ssl ? 1 : 0
  region      = var.region
  name_prefix = "${var.name}-certificate-"
  private_key = var.private_key
  certificate = var.certificate

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_url_map" "default" {
  project         = var.project
  count           = var.create_url_map ? 1 : 0
  name            = "${var.name}-url-map"
  region          = var.region
  default_service = google_compute_region_backend_service.default[keys(var.backends)[0]].self_link
}

resource "google_compute_region_url_map" "https_redirect" {
  project = var.project
  count   = var.https_redirect ? 1 : 0
  name    = "${var.name}-https-redirect"
  region  = var.region
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_region_backend_service" "default" {
  provider = google-beta
  for_each = var.backends

  project               = var.project
  name                  = "${var.name}-backend-${each.key}"
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"

  port_name = each.value.port_name
  protocol  = each.value.protocol

  timeout_sec                     = lookup(each.value, "timeout_sec", null)
  description                     = lookup(each.value, "description", null)
  connection_draining_timeout_sec = lookup(each.value, "connection_draining_timeout_sec", null)
  health_checks                   = lookup(each.value, "health_check", null) == null ? null : [google_compute_region_health_check.default[each.key].self_link]
  session_affinity                = lookup(each.value, "session_affinity", null)
  affinity_cookie_ttl_sec         = lookup(each.value, "affinity_cookie_ttl_sec", null)

  dynamic "backend" {
    for_each = toset(each.value["groups"])
    content {
      description = lookup(backend.value, "description", null)
      group       = lookup(backend.value, "group")

      balancing_mode               = lookup(backend.value, "balancing_mode") == null ? "UTILIZATION" : lookup(backend.value, "balancing_mode")
      capacity_scaler              = lookup(backend.value, "capacity_scaler") == null ? 0.9 : lookup(backend.value, "capacity_scaler")
      max_connections              = lookup(backend.value, "max_connections")
      max_connections_per_instance = lookup(backend.value, "max_connections_per_instance")
      max_connections_per_endpoint = lookup(backend.value, "max_connections_per_endpoint")
      max_rate                     = lookup(backend.value, "max_rate")
      max_rate_per_instance        = lookup(backend.value, "max_rate_per_instance")
      max_rate_per_endpoint        = lookup(backend.value, "max_rate_per_endpoint")
      max_utilization              = lookup(backend.value, "max_utilization")
    }
  }

  dynamic "log_config" {
    for_each = lookup(lookup(each.value, "log_config", {}), "enable", true) ? [1] : []
    content {
      enable      = lookup(lookup(each.value, "log_config", {}), "enable", true)
      sample_rate = lookup(lookup(each.value, "log_config", {}), "sample_rate", "1.0")
    }
  }

  dynamic "iap" {
    for_each = lookup(lookup(each.value, "iap_config", {}), "enable", false) ? [1] : []
    content {
      oauth2_client_id     = lookup(lookup(each.value, "iap_config", {}), "oauth2_client_id", "")
      oauth2_client_secret = lookup(lookup(each.value, "iap_config", {}), "oauth2_client_secret", "")
    }
  }

  depends_on = [
    google_compute_region_health_check.default
  ]
}


resource "google_compute_region_health_check" "default" {
  provider = google-beta
  for_each = local.health_checked_backends
  project  = var.project
  region   = var.region
  name     = "${var.name}-hc-${each.key}"

  check_interval_sec  = lookup(each.value["health_check"], "check_interval_sec", 5)
  timeout_sec         = lookup(each.value["health_check"], "timeout_sec", 5)
  healthy_threshold   = lookup(each.value["health_check"], "healthy_threshold", 2)
  unhealthy_threshold = lookup(each.value["health_check"], "unhealthy_threshold", 2)

  log_config {
    enable = lookup(each.value["health_check"], "logging", false)
  }

  dynamic "http_health_check" {
    for_each = each.value["protocol"] == "HTTP" ? [
      {
        host         = lookup(each.value["health_check"], "host", null)
        request_path = lookup(each.value["health_check"], "request_path", null)
        port         = lookup(each.value["health_check"], "port", null)
      }
    ] : []

    content {
      host         = lookup(http_health_check.value, "host", null)
      request_path = lookup(http_health_check.value, "request_path", null)
      port         = lookup(http_health_check.value, "port", null)
    }
  }

  dynamic "https_health_check" {
    for_each = each.value["protocol"] == "HTTPS" ? [
      {
        host         = lookup(each.value["health_check"], "host", null)
        request_path = lookup(each.value["health_check"], "request_path", null)
        port         = lookup(each.value["health_check"], "port", null)
      }
    ] : []

    content {
      host         = lookup(https_health_check.value, "host", null)
      request_path = lookup(https_health_check.value, "request_path", null)
      port         = lookup(https_health_check.value, "port", null)
    }
  }

  dynamic "http2_health_check" {
    for_each = each.value["protocol"] == "HTTP2" ? [
      {
        host         = lookup(each.value["health_check"], "host", null)
        request_path = lookup(each.value["health_check"], "request_path", null)
        port         = lookup(each.value["health_check"], "port", null)
      }
    ] : []

    content {
      host         = lookup(http2_health_check.value, "host", null)
      request_path = lookup(http2_health_check.value, "request_path", null)
      port         = lookup(http2_health_check.value, "port", null)
    }
  }
}