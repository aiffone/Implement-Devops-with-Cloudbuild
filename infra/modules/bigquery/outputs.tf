output "dataset_id" {
  description = "BigQuery dataset ID"
  value       = google_bigquery_dataset.this.dataset_id
}

output "dataset_location" {
  description = "BigQuery dataset location"
  value       = google_bigquery_dataset.this.location
}
