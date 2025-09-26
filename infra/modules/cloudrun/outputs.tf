output "service_name" {
  description = "Cloud Run service name"
  value       = google_cloud_run_service.this.name
}

output "service_url" {
  description = "Cloud Run service URL"
  value       = google_cloud_run_service.this.status[0].url
}
