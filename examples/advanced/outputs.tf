output "project_id" {
  description = "The ID of the SLS project."
  value       = module.sls_advanced.project_id
}

output "logstore_ids" {
  description = "The logstore IDs created within the SLS project."
  value       = module.sls_advanced.logstore_ids
}

output "logtail_config_ids" {
  description = "The Logtail configuration IDs created."
  value       = module.sls_advanced.logtail_config_ids
}

output "oss_export_ids" {
  description = "The OSS export IDs created."
  value       = module.sls_advanced.oss_export_ids
}
