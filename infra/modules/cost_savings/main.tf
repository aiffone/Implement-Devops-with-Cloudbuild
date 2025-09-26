# variables.tf (add these if you don't already have them)
# Create a Monitoring notification channel (email)
resource "google_monitoring_notification_channel" "email_channel" {
  project      = var.project_id
  display_name = "Billing Alert Email"
  type         = "email"
  labels = {
    email_address = var.billing_alert_email
  }
  enabled = true
}

# Billing budget with notifications attached
resource "google_billing_budget" "project_budget" {
  billing_account = var.billing_account_id
  display_name    = "${var.project_id}-budget"

  # optional: scope the budget to this project only
  budget_filter {
    projects = ["projects/${var.project_id}"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget_amount_usd
    }
  }

  # threshold notifications (optional, you can keep only all_updates_rule)
  threshold_rules {
    threshold_percent = 0.5 # 50%
  }
  threshold_rules {
    threshold_percent = 0.8 # 80%
  }

  # <-- THIS is the right block for notifications on every update:
  all_updates_rule {
    # pass the full monitoring notification channel resource name(s)
    monitoring_notification_channels = [
      google_monitoring_notification_channel.email_channel.id
    ]

    # optional flags
    disable_default_iam_recipients = false
    schema_version                 = "1.0"
  }
}
