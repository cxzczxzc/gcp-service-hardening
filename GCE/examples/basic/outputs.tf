output "my_test_region" {
  value = var.region
}

output "instance_template_self_link" {
  description = "Self-link of instance template"
  value       = module.module_under_test.instance_template_self_link
}

output "instance_template_name" {
  description = "Name of instance template"
  value       = module.module_under_test.instance_template_name
}

output "instance_template_tags" {
  description = "Tags that will be associated with instance(s)"
  value       = tolist(module.module_under_test.instance_template_tags)
}

output "mig_self_link" {
  description = "Self-link for managed instance group"
  value       = module.module_under_test.mig_self_link
}

output "mig_instance_group" {
  description = "Self-link of managed instance group"
  value       = module.module_under_test.mig_instance_group
}

output "mig_instance_group_manager" {
  description = "An instance of google_compute_region_instance_group_manager of the instance group."
  value       = module.module_under_test.mig_instance_group_manager
}

output "mig_instance_group_manager_region" {
  description = "An instance of google_compute_region_instance_group_manager of the instance group."
  value       = module.module_under_test.mig_instance_group_manager.region
}

output "mig_health_check_self_links" {
  description = "An instance of google_compute_region_instance_group_manager of the instance group."
  value       = module.module_under_test.mig_health_check_self_links
}