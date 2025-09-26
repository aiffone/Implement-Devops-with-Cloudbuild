variable "project_id" {
  type        = string
  description = "The project ID where the bucket will be created."
}

variable "project_number" {
  type        = string
  description = "The project number (needed for bucket service account binding)."
}

variable "region" {
  type        = string
  description = "The region for the bucket."
}

variable "bucket_name" {
  type        = string
  description = "The name of the storage bucket."
}

variable "kms_key_id" {
  type        = string
  description = "The KMS key ID used for bucket encryption."
}
