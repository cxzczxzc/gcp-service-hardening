output "http_proxy" {
  value = element(split("/", module.http_ilb.http_proxy[0]), length(split("/", module.http_ilb.http_proxy[0])) - 1)
}

output "https_proxy" {
  value = element(split("/", module.http_ilb.https_proxy[0]), length(split("/", module.http_ilb.https_proxy[0])) - 1)
}

output "url_map" {
  value = element(split("/", module.http_ilb.url_map[0]), length(split("/", module.http_ilb.url_map[0])) - 1)
}