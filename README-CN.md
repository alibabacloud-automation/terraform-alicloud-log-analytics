阿里云日志服务（SLS）Terraform 模块

# terraform-alicloud-log-analytics

[English](https://github.com/alibabacloud-automation/terraform-alicloud-log-analytics/blob/main/README.md) | 简体中文

在阿里云上创建[日志服务（SLS）](https://help.aliyun.com/zh/sls/)资源的 Terraform 模块。

该模块可以一站式创建 SLS 日志项目、日志库、Logtail 采集配置、OSS 数据投递、私网连接 VPC 终端节点以及 RAM 角色访问控制等资源。

## 使用方法

创建一个 SLS 项目和日志库，用于集中式日志管理。

```terraform
module "sls" {
  source  = "alibabacloud-automation/log-analytics/alicloud"

  project_name = "my-sls-project"

  logstores = {
    app_logs = {
      logstore_name    = "app-logs"
      retention_period = 180
      shard_count      = 2
    }
  }
}
```

## 示例

* [基础示例](https://github.com/alibabacloud-automation/terraform-alicloud-log-analytics/tree/main/examples/basic)
* [高级示例](https://github.com/alibabacloud-automation/terraform-alicloud-log-analytics/tree/main/examples/advanced)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.190.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.190.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_log_project.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/log_project) | resource |
| [alicloud_log_store.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/log_store) | resource |
| [alicloud_logtail_config.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/logtail_config) | resource |
| [alicloud_privatelink_vpc_endpoint.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/privatelink_vpc_endpoint) | resource |
| [alicloud_ram_role.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_role) | resource |
| [alicloud_ram_role_policy_attachment.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_role_policy_attachment) | resource |
| [alicloud_sls_oss_export_sink.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/sls_oss_export_sink) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_ram_role"></a> [create\_ram\_role](#input\_create\_ram\_role) | Whether to create a RAM role for SLS access control. | `bool` | `false` | no |
| <a name="input_logstores"></a> [logstores](#input\_logstores) | A map of logstore configurations to create within the SLS project. | <pre>map(object({<br/>    logstore_name         = string<br/>    retention_period      = optional(number, 30)<br/>    shard_count           = optional(number, 2)<br/>    auto_split            = optional(bool, true)<br/>    max_split_shard_count = optional(number, 60)<br/>    append_meta           = optional(bool, true)<br/>    enable_web_tracking   = optional(bool, false)<br/>    hot_ttl               = optional(number, 30)<br/>    infrequent_access_ttl = optional(number, null)<br/>    mode                  = optional(string, "standard")<br/>    telemetry_type        = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_logtail_configs"></a> [logtail\_configs](#input\_logtail\_configs) | A map of Logtail configurations to create for log collection. | <pre>map(object({<br/>    logstore     = string<br/>    input_type   = string<br/>    name         = string<br/>    output_type  = optional(string, "LogService")<br/>    input_detail = string<br/>    log_sample   = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_oss_exports"></a> [oss\_exports](#input\_oss\_exports) | A map of OSS export configurations for log data delivery. | <pre>map(object({<br/>    logstore_name    = string<br/>    export_name      = string<br/>    display_name     = string<br/>    bucket           = string<br/>    role_arn         = string<br/>    sink_role_arn    = string<br/>    from_time        = string<br/>    to_time          = string<br/>    time_zone        = optional(string, "+0800")<br/>    content_type     = optional(string, "json")<br/>    compression_type = optional(string, "none")<br/>    content_detail   = optional(string, null)<br/>    buffer_interval  = optional(string, "300")<br/>    buffer_size      = optional(string, "256")<br/>    endpoint         = string<br/>  }))</pre> | `{}` | no |
| <a name="input_private_endpoint_config"></a> [private\_endpoint\_config](#input\_private\_endpoint\_config) | Configuration for the PrivateLink VPC endpoint to access SLS privately. | <pre>object({<br/>    enabled            = bool<br/>    vpc_id             = optional(string, null)<br/>    security_group_ids = optional(list(string), [])<br/>    service_name       = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "security_group_ids": [],<br/>  "service_name": null,<br/>  "vpc_id": null<br/>}</pre> | no |
| <a name="input_project_description"></a> [project\_description](#input\_project\_description) | The description of the SLS project. | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the SLS project. | `string` | n/a | yes |
| <a name="input_project_policy"></a> [project\_policy](#input\_project\_policy) | The policy of the SLS project. | `string` | `null` | no |
| <a name="input_project_tags"></a> [project\_tags](#input\_project\_tags) | A mapping of tags to assign to the SLS project. | `map(string)` | `{}` | no |
| <a name="input_ram_role"></a> [ram\_role](#input\_ram\_role) | RAM role configuration for SLS access control. | <pre>object({<br/>    description                 = optional(string, null)<br/>    assume_role_policy_document = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "assume_role_policy_document": null,<br/>  "description": null<br/>}</pre> | no |
| <a name="input_ram_role_policies"></a> [ram\_role\_policies](#input\_ram\_role\_policies) | A map of policies to attach to the RAM role. | <pre>map(object({<br/>    policy_name = string<br/>    policy_type = optional(string, "System")<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the resource group to which the SLS project belongs. | `string` | `null` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the RAM role to create. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logstore_ids"></a> [logstore\_ids](#output\_logstore\_ids) | A map of logstore IDs. |
| <a name="output_logtail_config_ids"></a> [logtail\_config\_ids](#output\_logtail\_config\_ids) | A map of Logtail configuration IDs. |
| <a name="output_oss_export_ids"></a> [oss\_export\_ids](#output\_oss\_export\_ids) | A map of OSS export sink IDs. |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | The ID of the PrivateLink VPC endpoint, or null if not enabled. |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of the SLS project. |
| <a name="output_ram_role_id"></a> [ram\_role\_id](#output\_ram\_role\_id) | The ID of the RAM role, or null if not enabled. |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
