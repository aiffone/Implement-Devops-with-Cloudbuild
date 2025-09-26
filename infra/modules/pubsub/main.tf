resource "google_pubsub_topic" "this" {
  name    = var.topic_name
  project = var.project_id
}

resource "google_pubsub_subscription" "this" {
  name  = "${var.topic_name}-sub"
  topic = google_pubsub_topic.this.name
}
