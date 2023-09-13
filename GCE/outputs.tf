output "instance_template_self_link" {
  description = "Self-link of instance template"
  value       = module.instance_template.self_link
}

output "instance_template_name" {
  description = "Name of instance template"
  value       = module.instance_template.name
}

output "instance_template_tags" {
  description = "Tags that will be associated with instance(s)"
  value       = module.instance_template.tags
}

output "mig_self_link" {
  description = "Self-link for managed instance group"
  value       = module.mig.self_link
}

output "mig_instance_group" {
  description = "Self-link of managed instance group"
  value       = module.mig.instance_group
}

output "mig_instance_group_manager" {
  description = "An instance of google_compute_region_instance_group_manager of the instance group."
  value       = module.mig.instance_group_manager
}

output "mig_health_check_self_links" {
  description = "An instance of google_compute_region_instance_group_manager of the instance group."
  value       = module.mig.health_check_self_links
}
