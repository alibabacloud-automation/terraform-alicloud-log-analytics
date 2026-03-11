module "sls_basic" {
  source = "../.."

  project_name        = "tf-basic-sls-project"
  project_description = "Basic SLS project created by Terraform"

  logstores = {
    default_logstore = {
      logstore_name    = "default-logstore"
      retention_period = 30
      shard_count      = 2
    }
  }
}
