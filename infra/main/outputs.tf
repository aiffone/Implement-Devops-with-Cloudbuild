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

# --- FlyBot BigQuery Outputs ---
output "bigquery_dataset_id" {
  description = "BigQuery dataset ID created for FlyBot"
  value       = module.bigquery_flybot.dataset_id
}

# --- FlyBot Storage Outputs ---
output "storage_bucket_name" {
  description = "GCS bucket name created for FlyBot"
  value       = module.storage_flybot.bucket_name
}

# --- FlyBot Cloud Run Outputs ---
output "cloudrun_service_name" {
  description = "Cloud Run service name for FlyBot"
  value       = module.cloudrun_flybot.service_name
}

output "cloudrun_service_url" {
  description = "Cloud Run service URL for FlyBot"
  value       = module.cloudrun_flybot.service_url
}

# --- FlyBot Pub/Sub Outputs ---
output "pubsub_topic_name" {
  description = "Pub/Sub topic name for FlyBot"
  value       = module.pubsub_flybot.topic_name
}

output "pubsub_subscription_name" {
  description = "Pub/Sub subscription name for FlyBot"
  value       = module.pubsub_flybot.subscription_name
}

# --- Cost / Budget Outputs ---
output "budget_amount_usd" {
  description = "Configured monthly budget amount for FlyBot"
  value       = module.cost_savings.budget_amount_usd
}

output "billing_alert_email" {
  description = "Email set to receive billing alerts for FlyBot"
  value       = module.cost_savings.billing_alert_email
}
