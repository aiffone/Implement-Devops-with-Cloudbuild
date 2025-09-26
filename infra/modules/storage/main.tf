resource "google_storage_bucket" "this" {
  name     = var.bucket_name
  project  = var.project_id
  location = var.region

  # Enforce uniform permissions (no legacy ACLs)
  uniform_bucket_level_access = true

  encryption {
    default_kms_key_name = var.kms_key_id
  }
}

resource "google_kms_crypto_key_iam_member" "this" {
  crypto_key_id = var.kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"
}
