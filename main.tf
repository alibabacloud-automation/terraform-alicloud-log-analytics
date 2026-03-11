resource "alicloud_log_project" "this" {
  project_name      = var.project_name
  description       = var.project_description
  resource_group_id = var.resource_group_id
  tags              = var.project_tags
  policy            = var.project_policy
}

resource "alicloud_log_store" "this" {
  for_each = var.logstores

  project_name          = alicloud_log_project.this.project_name
  logstore_name         = each.value.logstore_name
  retention_period      = each.value.retention_period
  shard_count           = each.value.shard_count
  auto_split            = each.value.auto_split
  max_split_shard_count = each.value.max_split_shard_count
  append_meta           = each.value.append_meta
  enable_web_tracking   = each.value.enable_web_tracking
  hot_ttl               = each.value.hot_ttl
  infrequent_access_ttl = each.value.infrequent_access_ttl
  mode                  = each.value.mode
  telemetry_type        = each.value.telemetry_type
}

resource "alicloud_logtail_config" "this" {
  for_each = var.logtail_configs

  project      = alicloud_log_project.this.project_name
  logstore     = alicloud_log_store.this[each.value.logstore].logstore_name
  input_type   = each.value.input_type
  name         = each.value.name
  output_type  = each.value.output_type
  input_detail = each.value.input_detail
  log_sample   = each.value.log_sample
}

resource "alicloud_sls_oss_export_sink" "this" {
  for_each = var.oss_exports

  project      = alicloud_log_project.this.project_name
  job_name     = each.value.export_name
  display_name = each.value.display_name

  configuration {
    logstore  = alicloud_log_store.this[each.value.logstore_name].logstore_name
    role_arn  = var.create_ram_role ? alicloud_ram_role.this[0].arn : each.value.role_arn
    from_time = each.value.from_time
    to_time   = each.value.to_time

    sink {
      bucket           = each.value.bucket
      role_arn         = var.create_ram_role ? alicloud_ram_role.this[0].arn : each.value.sink_role_arn
      time_zone        = each.value.time_zone
      content_type     = each.value.content_type
      compression_type = each.value.compression_type
      content_detail   = each.value.content_detail
      buffer_interval  = each.value.buffer_interval
      buffer_size      = each.value.buffer_size
      endpoint         = each.value.endpoint
    }
  }
}

resource "alicloud_privatelink_vpc_endpoint" "this" {
  count = var.private_endpoint_config.enabled ? 1 : 0

  vpc_id                        = var.private_endpoint_config.vpc_id
  endpoint_type                 = "Interface"
  service_name                  = var.private_endpoint_config.service_name
  vpc_endpoint_name             = "${var.project_name}-private-endpoint"
  endpoint_description          = "Private endpoint for ${var.project_name} SLS project"
  security_group_ids            = var.private_endpoint_config.security_group_ids
  zone_private_ip_address_count = 1
}

resource "alicloud_ram_role" "this" {
  count = var.create_ram_role ? 1 : 0

  role_name = var.role_name
  assume_role_policy_document = var.ram_role.assume_role_policy_document != null ? var.ram_role.assume_role_policy_document : jsonencode({
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = ["log.aliyuncs.com"] }
    }]
    Version = "1"
  })
  description = var.ram_role.description != null ? var.ram_role.description : "RAM role for SLS project ${var.project_name}"
}

resource "alicloud_ram_role_policy_attachment" "this" {
  for_each = var.create_ram_role ? var.ram_role_policies : {}

  role_name   = alicloud_ram_role.this[0].role_name
  policy_name = each.value.policy_name
  policy_type = each.value.policy_type
}
