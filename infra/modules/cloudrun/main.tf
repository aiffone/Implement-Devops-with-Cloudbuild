resource "google_service_account" "cloudrun_sa" {
  account_id   = "${var.service_name}-sa"
  display_name = "Cloud Run Service Account"
  project      = var.project_id
}

resource "google_cloud_run_service" "this" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = var.image
        env {
          name  = "PUBSUB_TOPIC"
          value = var.pubsub_topic_name
        }
      }
      service_account_name = google_service_account.cloudrun_sa.email
    }
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "all_users_invoker" {
  location = google_cloud_run_service.this.location
  project  = var.project_id
  service  = google_cloud_run_service.this.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
