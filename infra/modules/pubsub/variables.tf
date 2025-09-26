variable "project_id" {
  description = "The GCP project ID where the Pub/Sub resources will be created"
  type        = string
}

variable "topic_name" {
  description = "The name of the Pub/Sub topic"
  type        = string
}
