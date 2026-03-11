# Basic SLS Project Example

This example demonstrates how to create a basic SLS (Log Service) project using the alicloud-log-analytics module.

## Resources Created

- SLS Project
- Basic Logstore

## Variables

- `region`: The Alibaba Cloud region to deploy resources in
- `project_name`: The name of the SLS project
- `project_description`: The description of the SLS project

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