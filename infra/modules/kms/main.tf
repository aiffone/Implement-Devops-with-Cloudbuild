resource "google_kms_key_ring" "this" {
  name     = "${var.bucket_name}-keyring"
  project  = var.project_id
  location = var.region
}

resource "google_kms_crypto_key" "this" {
  name            = "${var.bucket_name}-key"
  key_ring        = google_kms_key_ring.this.id
  rotation_period = "7776000s" # 90 days
}
