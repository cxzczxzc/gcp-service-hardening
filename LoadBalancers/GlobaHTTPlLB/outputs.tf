output "external_ip" {
  description = "The external IPv4 assigned to the global fowarding rule."
  value       = module.gce-lb-http.external_ip
}

output "https_proxy" {
  description = "HTTPS proxy used by the GLB."
  value       = module.gce-lb-http.https_proxy
}

output "url_map" {
  description = "URL map bound to the GCL."
  value       = module.gce-lb-http.url_map
}
