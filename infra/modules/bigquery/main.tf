resource "google_bigquery_dataset" "this" {
  dataset_id                 = var.dataset_id
  project                    = var.project_id
  location                   = var.location
  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "this" {
  dataset_id = google_bigquery_dataset.this.dataset_id
  table_id   = "property_events"
  project    = var.project_id

  schema = <<EOF
[
  {"name": "event_id", "type": "STRING", "mode": "REQUIRED"},
  {"name": "timestamp", "type": "TIMESTAMP", "mode": "REQUIRED"},
  {"name": "address", "type": "STRING", "mode": "NULLABLE"},
  {"name": "price", "type": "FLOAT", "mode": "NULLABLE"}
]
EOF
}
