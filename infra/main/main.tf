terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }

  backend "gcs" {
    bucket = "tf-state-concepts-maven"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# --- Shared VPC Module ---
module "vpc" {
  source       = "../modules/vpc"
  project_id   = var.project_id
  region       = var.region
  network_name = var.vpc_network_name
}

# --- Shared IAM Module --- 
module "iam" {
  source     = "../modules/iam"
  project_id = var.project_id
}

# --- Shared KMS Module ---
module "kms" {
  source      = "../modules/kms"
  project_id  = var.project_id
  region      = var.region
  bucket_name = var.storage_bucket_name
}

# --- BigQuery for hello ---
module "bigquery_hello" {
  source     = "../modules/bigquery"
  project_id = var.project_id
  region     = var.region
  dataset_id = "${var.resource_prefix}_${var.bigquery_dataset_id}"
  location   = var.bigquery_location
}

# --- Storage for hello --- 
module "storage_hello" {
  source         = "../modules/storage"
  project_id     = var.project_id
  project_number = var.project_number
  region         = var.region
  bucket_name    = "${var.resource_prefix}-${var.storage_bucket_name}"
  kms_key_id     = module.kms.crypto_key_id
}

# --- Cloud Run for hello ---
module "cloudrun_hello" {
  source            = "../modules/cloudrun"
  project_id        = var.project_id
  region            = var.region
  pubsub_topic_name = "${var.resource_prefix}-${var.pubsub_topic_name}"
  image             = var.cloudrun_image
  service_name      = "${var.resource_prefix}-${var.cloudrun_service_name}"
}

# --- Pub/Sub for hello ---
module "pubsub_hello" {
  source     = "../modules/pubsub"
  project_id = var.project_id
  topic_name = "${var.resource_prefix}-${var.pubsub_topic_name}"
}

# --- Cost Savings / Billing Module ---
module "cost_savings" {
  source              = "../modules/cost_savings"
  project_id          = var.project_id
  billing_account_id  = var.billing_account_id
  billing_alert_email = var.billing_alert_email
  budget_amount_usd   = var.budget_amount_usd
}
