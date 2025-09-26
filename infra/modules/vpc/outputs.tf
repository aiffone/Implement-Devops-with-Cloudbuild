output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.this.name
}

output "subnet_names" {
  description = "List of subnet names"
  value       = [google_compute_subnetwork.this.name] # wrap in a list to keep type consistent
}
