resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "alicloud_oss_bucket" "backup_bucket" {
  bucket = "tf-sls-backup-${random_string.bucket_suffix.result}"
}

resource "alicloud_oss_bucket_acl" "backup_bucket_acl" {
  bucket = alicloud_oss_bucket.backup_bucket.id
  acl    = "private"
}

module "sls_advanced" {
  source = "../.."

  project_name        = "tf-advanced-sls-${random_string.bucket_suffix.result}"
  project_description = "Advanced SLS project with multiple configurations"
  project_tags = {
    Environment = "production"
    Team        = "analytics"
  }

  # Enable automatic RAM role creation
  create_ram_role = true
  role_name       = "tf-sls-role-${random_string.bucket_suffix.result}"

  # Define RAM role configuration
  ram_role = {
    description = "RAM role for SLS project tf-advanced-sls-${random_string.bucket_suffix.result}"
  }

  # Attach necessary policies to the role
  ram_role_policies = {
    oss_export_policy = {
      policy_name = "AliyunOSSFullAccess"
      policy_type = "System"
    },
    log_access_policy = {
      policy_name = "AliyunLogFullAccess"
      policy_type = "System"
    }
  }

  logstores = {
    application_logs = {
      logstore_name         = "application-logs"
      retention_period      = 180
      shard_count           = 3
      auto_split            = true
      max_split_shard_count = 60
      append_meta           = true
    }
    audit_logs = {
      logstore_name    = "audit-logs"
      retention_period = 365
      shard_count      = 2
      hot_ttl          = 7
      mode             = "standard"
    }
  }

  logtail_configs = {
    app_logtail = {
      logstore   = "application_logs"
      input_type = "file"
      name       = "app-logtail-config"
      input_detail = jsonencode({
        logPath        = "/app/logs"
        filePattern    = "*.log"
        logType        = "json_log"
        topicFormat    = "default"
        discardUnmatch = false
        enableRawLog   = true
        fileEncoding   = "utf8"
        maxDepth       = 10
      })
    }
  }

  oss_exports = {
    backup_export = {
      export_name     = "backup-export"
      display_name    = "Backup Export to OSS"
      bucket          = alicloud_oss_bucket.backup_bucket.bucket
      role_arn        = ""         # Will be handled by the module when create_ram_role=true
      sink_role_arn   = ""         # Will be handled by the module when create_ram_role=true
      from_time       = 1741680000 # 2026-03-11 00:00:00 UTC
      to_time         = 1773216000 # 2027-03-11 00:00:00 UTC
      endpoint        = "https://oss-cn-hangzhou-internal.aliyuncs.com"
      buffer_interval = 300
      buffer_size     = 250
      content_type    = "json"
      content_detail  = "{}"
      time_zone       = "+0800"
      logstore_name   = "application_logs"
      json_enable_tag = true
      compress_type   = "none"
      path_format     = "%Y/%m/%d/%H/%M"
    }
  }
}
