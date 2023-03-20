module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 6.3"

  project                         = var.project
  name                            = var.name
  backends                        = var.backends
  create_address                  = var.create_address
  address                         = var.address
  enable_ipv6                     = var.enable_ipv6
  create_ipv6_address             = var.create_ipv6_address
  ipv6_address                    = var.ipv6_address
  create_url_map                  = var.create_url_map
  url_map                         = var.url_map
  http_forward                    = var.http_forward
  ssl                             = var.ssl
  ssl_policy                      = var.ssl_policy == null ? google_compute_ssl_policy.dnb-ssl-policy.id : var.ssl_policy
  quic                            = var.quic
  private_key                     = var.private_key
  certificate                     = var.certificate
  managed_ssl_certificate_domains = var.managed_ssl_certificate_domains
  use_ssl_certificates            = var.use_ssl_certificates
  ssl_certificates                = var.ssl_certificates
  cdn                             = var.cdn
  https_redirect                  = var.https_redirect
  random_certificate_suffix       = var.random_certificate_suffix
  labels                          = var.labels
  firewall_networks               = []
}

# DnB's default SSL policy
resource "google_compute_ssl_policy" "dnb-ssl-policy" {
  project         = var.project
  name            = "dnb-ssl-policy"
  min_tls_version = "TLS_1_2"
  profile         = var.ssl_profile == "CUSTOM" ? "CUSTOM" : "MODERN" #only ECDHE ciphers are allowed in MODERN profile. See: https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#defining_an_ssl_policy
  custom_features = var.ssl_profile == "CUSTOM" ? var.ssl_custom_features : []
}
