#httpFunc
output "httpfunc_region" {
  value = module.http_cloudfunction.region
}

output "httpfunc_service_account_email" {
  value = module.http_cloudfunction.service_account_email
}

output "httpfunc_cloudfunction_id" {
  value = module.http_cloudfunction.cloudfunction_id
}

output "httpfunc_cloudfunction_https_trigger_url" {
  value = module.http_cloudfunction.cloudfunction_https_trigger_url
}

#pubsubFunc
output "pubsubfunc_region" {
  value = module.pubsub_cloudfunction.region
}

output "pubsubfunc_service_account_email" {
  value = module.pubsub_cloudfunction.service_account_email
}

output "pubsubfunc_cloudfunction_id" {
  value = module.pubsub_cloudfunction.cloudfunction_id
}

#storage

output "storagefunc_region" {
  value = module.storage_cloudfunction.region
}

output "storagefunc_service_account_email" {
  value = module.storage_cloudfunction.service_account_email
}

output "storagefunc_cloudfunction_id" {
  value = module.storage_cloudfunction.cloudfunction_id
}
