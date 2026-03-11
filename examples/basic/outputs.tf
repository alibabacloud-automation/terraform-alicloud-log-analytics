output "project_id" {
  description = "The ID of the SLS project."
  value       = module.sls_basic.project_id
}

output "logstore_ids" {
  description = "The logstore IDs created within the SLS project."
  value       = module.sls_basic.logstore_ids
}
