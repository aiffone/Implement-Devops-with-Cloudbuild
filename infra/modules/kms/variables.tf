variable "project_id" {
  type        = string
  description = "The project ID where the KMS resources will be created."
}

variable "region" {
  type        = string
  description = "The location/region for the KMS key ring."
}

variable "bucket_name" {
  type        = string
  description = "The bucket name used to derive the KMS key ring and key names."
}
