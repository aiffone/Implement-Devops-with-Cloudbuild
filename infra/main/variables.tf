variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "The default region for resources"
  type        = string
  default     = "us-central1"
}

variable "billing_account_id" {
  description = "The billing account ID to attach budgets"
  type        = string
}

variable "billing_alert_email" {
  description = "The email address to receive billing alerts"
  type        = string
}

variable "budget_amount_usd" {
  description = "The monthly budget limit in USD"
  type        = number
  default     = 10
}

# ---- VPC ----
variable "vpc_network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "flybot-network"
}

# ---- BigQuery ----
variable "bigquery_dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
  default     = "flybot_dataset"
}

variable "bigquery_location" {
  description = "Location for BigQuery dataset"
  type        = string
  default     = "US"
}

# ---- Storage ----
variable "storage_bucket_name" {
  description = "GCS bucket name for FlyBot data"
  type        = string
  default     = "flybot-storage"
}

# ---- Cloud Run ----
variable "cloudrun_service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "flybot-api"
}

locals {
  cloudrun_image = "gcr.io/${var.project_id}/flybot-api:latest"
}

# ---- Pub/Sub ----
variable "pubsub_topic_name" {
  description = "Name of the Pub/Sub topic"
  type        = string
  default     = "flybot-events"
}

variable "project_number" {
  type        = string
  description = "The numeric ID of the project (required for CMEK IAM bindings)."
}

variable "cloudrun_image" {
  description = "Docker image to deploy for Cloud Run service"
  type        = string
}

variable "resource_prefix" {
  type        = string
  description = "Prefix to distinguish resources created by this repo/project (e.g., flybot)"
  default     = "flybot"
}
