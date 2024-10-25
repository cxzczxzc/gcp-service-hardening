output "asymmetric_keys" {
  value       = module.kms.asymmetric_keys
  description = "Map of generated asymmetric crypto keys."
}

output "symmetric_keys" {
  value       = module.kms.symmetric_keys
  description = "Map of generated symmetric crypto keys."
}

output "symmetric_keys_auto_rotate" {
  value       = module.kms.symmetric_keys_auto_rotate
  description = "Map of generated symmetric crypto keys auto rotate."
}