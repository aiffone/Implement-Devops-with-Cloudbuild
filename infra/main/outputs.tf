# --- Shared / VPC Outputs ---
output "vpc_network_name" {
  description = "Name of the shared VPC network"
  value       = module.vpc.network_name
}

output "vpc_subnets" {
  description = "List of subnet names created in the shared VPC"
  value       = module.vpc.subnet_names
}

# --- Shared / IAM Outputs ---
output "service_accounts" {
  description = "List of IAM service accounts created"
  value       = module.iam.service_accounts
}

# --- hello BigQuery Outputs ---
output "bigquery_dataset_id" {
  description = "BigQuery dataset ID created for hello"
  value       = module.bigquery_hello.dataset_id
}

# --- hello Storage Outputs ---
output "storage_bucket_name" {
  description = "GCS bucket name created for hello"
  value       = module.storage_hello.bucket_name
}

# --- hello Cloud Run Outputs ---
output "cloudrun_service_name" {
  description = "Cloud Run service name for hello"
  value       = module.cloudrun_hello.service_name
}

output "cloudrun_service_url" {
  description = "Cloud Run service URL for hello"
  value       = module.cloudrun_hello.service_url
}

# --- hello Pub/Sub Outputs ---
output "pubsub_topic_name" {
  description = "Pub/Sub topic name for hello"
  value       = module.pubsub_hello.topic_name
}

output "pubsub_subscription_name" {
  description = "Pub/Sub subscription name for hello"
  value       = module.pubsub_hello.subscription_name
}

# --- Cost / Budget Outputs ---
output "budget_amount_usd" {
  description = "Configured monthly budget amount for hello"
  value       = module.cost_savings.budget_amount_usd
}

output "billing_alert_email" {
  description = "Email set to receive billing alerts for hello"
  value       = module.cost_savings.billing_alert_email
}
