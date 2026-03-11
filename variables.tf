variable "project_name" {
  description = "The name of the SLS project."
  type        = string
  nullable    = false
}

variable "project_description" {
  description = "The description of the SLS project."
  type        = string
  default     = null
}

variable "project_tags" {
  description = "A mapping of tags to assign to the SLS project."
  type        = map(string)
  default     = {}
}

variable "resource_group_id" {
  description = "The ID of the resource group to which the SLS project belongs."
  type        = string
  default     = null
}

variable "project_policy" {
  description = "The policy of the SLS project."
  type        = string
  default     = null
}

variable "logstores" {
  description = "A map of logstore configurations to create within the SLS project."
  type = map(object({
    logstore_name         = string
    retention_period      = optional(number, 30)
    shard_count           = optional(number, 2)
    auto_split            = optional(bool, true)
    max_split_shard_count = optional(number, 60)
    append_meta           = optional(bool, true)
    enable_web_tracking   = optional(bool, false)
    hot_ttl               = optional(number, 30)
    infrequent_access_ttl = optional(number, null)
    mode                  = optional(string, "standard")
    telemetry_type        = optional(string, null)
  }))
  default = {}
}

variable "logtail_configs" {
  description = "A map of Logtail configurations to create for log collection."
  type = map(object({
    logstore     = string
    input_type   = string
    name         = string
    output_type  = optional(string, "LogService")
    input_detail = string
    log_sample   = optional(string, null)
  }))
  default = {}
}

variable "oss_exports" {
  description = "A map of OSS export configurations for log data delivery."
  type = map(object({
    logstore_name    = string
    export_name      = string
    display_name     = string
    bucket           = string
    role_arn         = string
    sink_role_arn    = string
    from_time        = string
    to_time          = string
    time_zone        = optional(string, "+0800")
    content_type     = optional(string, "json")
    compression_type = optional(string, "none")
    content_detail   = optional(string, null)
    buffer_interval  = optional(string, "300")
    buffer_size      = optional(string, "256")
    endpoint         = string
  }))
  default = {}
}

variable "private_endpoint_config" {
  description = "Configuration for the PrivateLink VPC endpoint to access SLS privately."
  type = object({
    enabled            = bool
    vpc_id             = optional(string, null)
    security_group_ids = optional(list(string), [])
    service_name       = optional(string, null)
  })
  default = {
    enabled            = false
    vpc_id             = null
    security_group_ids = []
    service_name       = null
  }
}

variable "create_ram_role" {
  description = "Whether to create a RAM role for SLS access control."
  type        = bool
  default     = false
}

variable "role_name" {
  description = "The name of the RAM role to create."
  type        = string
  default     = null
}

variable "ram_role" {
  description = "RAM role configuration for SLS access control."
  type = object({
    description                 = optional(string, null)
    assume_role_policy_document = optional(string, null)
  })
  default = {
    description                 = null
    assume_role_policy_document = null
  }
}

variable "ram_role_policies" {
  description = "A map of policies to attach to the RAM role."
  type = map(object({
    policy_name = string
    policy_type = optional(string, "System")
  }))
  default = {}
}
