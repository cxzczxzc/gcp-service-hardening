output "external_ip" {
  value = module.gce-lb-http.external_ip
}

output "https_proxy" {
  description = "HTTPS proxy used by the GLB."
  value       = element(split("/", module.gce-lb-http.https_proxy[0]), length(split("/", module.gce-lb-http.https_proxy[0])) - 1)
}

output "url_map" {
  description = "URL map bound to the GCL."
  value       = element(split("/", module.gce-lb-http.url_map[0]), length(split("/", module.gce-lb-http.url_map[0])) - 1)
}
