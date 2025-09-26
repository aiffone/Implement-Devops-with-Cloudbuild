# ---- Variables ----
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID to attach budgets"
  type        = string
}

variable "billing_alert_email" {
  description = "Email to receive billing alerts"
  type        = string
}

variable "budget_amount_usd" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 10
}
