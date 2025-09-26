# modules/cloudrun/variables.tf

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the Cloud Run service"
  type        = string
  default     = "us-central1"
}

variable "image" {
  description = "Container image for the Cloud Run service"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "property-api"
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic to send events to"
  type        = string
  default     = "property-events"
}
