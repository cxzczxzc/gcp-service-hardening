output "name" {
  description = "ILB/Backend name"
  value       = module.tcp_ilb.name
}

output "forwarding_rule" {
  description = "The forwarding rule self_link."
  value       = module.tcp_ilb.forwarding_rule
}

output "forwarding_rule_id" {
  description = "The forwarding rule id."
  value       = module.tcp_ilb.forwarding_rule_id
}