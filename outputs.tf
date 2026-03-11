output "project_id" {
  description = "The ID of the SLS project."
  value       = alicloud_log_project.this.id
}

output "logstore_ids" {
  description = "A map of logstore IDs."
  value = {
    for k, v in alicloud_log_store.this : k => v.id
  }
}

output "logtail_config_ids" {
  description = "A map of Logtail configuration IDs."
  value = {
    for k, v in alicloud_logtail_config.this : k => v.id
  }
}

output "oss_export_ids" {
  description = "A map of OSS export sink IDs."
  value = {
    for k, v in alicloud_sls_oss_export_sink.this : k => v.id
  }
}

output "private_endpoint_id" {
  description = "The ID of the PrivateLink VPC endpoint, or null if not enabled."
  value       = length(alicloud_privatelink_vpc_endpoint.this) > 0 ? alicloud_privatelink_vpc_endpoint.this[0].id : null
}

output "ram_role_id" {
  description = "The ID of the RAM role, or null if not enabled."
  value       = length(alicloud_ram_role.this) > 0 ? alicloud_ram_role.this[0].id : null
}
