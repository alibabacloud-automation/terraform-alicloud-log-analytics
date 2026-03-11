# Advanced SLS Project Example

This example demonstrates how to create an advanced SLS (Log Service) project with multiple configurations using the alicloud-log-analytics module.

## Resources Created

- SLS Project with tags
- Multiple Logstores (application logs and audit logs)
- Logtail configuration for log collection
- OSS export for data backup
- RAM roles for access control
- OSS bucket for backup storage

## Variables

- `region`: The Alibaba Cloud region to deploy resources in
- `project_name`: The name of the SLS project
- `project_description`: The description of the SLS project
- `oss_bucket_name`: The name of the OSS bucket for backup exports

## Usage

To run this example, execute:

```bash
terraform init
terraform plan
terraform apply
```

To clean up resources:

```bash
terraform destroy
```

## Architecture

This example sets up a comprehensive logging solution with:

1. Two different logstores for application and audit logs with different retention periods
2. Logtail configuration to collect logs from application servers
3. Automatic export of logs to OSS for long-term storage
4. IAM roles for access control