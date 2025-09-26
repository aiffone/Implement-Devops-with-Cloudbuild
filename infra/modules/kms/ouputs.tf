output "crypto_key_id" {
  description = "The full resource ID of the CMEK crypto key."
  value       = google_kms_crypto_key.this.id
}

output "crypto_key_name" {
  description = "The name of the CMEK crypto key."
  value       = google_kms_crypto_key.this.name
}

output "key_ring_id" {
  description = "The ID of the KMS key ring."
  value       = google_kms_key_ring.this.id
}
