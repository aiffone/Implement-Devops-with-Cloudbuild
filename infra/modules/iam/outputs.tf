output "service_accounts" {
  description = "List of IAM service accounts created"
  value       = [google_service_account.this.email]
}
