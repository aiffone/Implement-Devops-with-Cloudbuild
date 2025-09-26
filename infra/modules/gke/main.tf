# tfsec:ignore:google-gke-enforce-pod-security-policy -- PSP is deprecated in GKE 1.25+
resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  networking_mode     = "VPC_NATIVE"
  initial_node_count  = 1 # 👈 REQUIRED for default node pool
  deletion_protection = false

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {}

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_config {
    service_account = var.node_service_account_email

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    metadata = {
      disable-legacy-endpoints = true
    }
    disk_size_gb = 50            # reduce default disk size (default is 100 GB)
    disk_type    = "pd-standard" # use standard persistent disk to save quota
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    # master_ipv4_cidr_block = "172.16.0.16/28" # optional
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.0/8"
      display_name = "admin"
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  resource_labels = {
    environment = "dev"
    owner       = "platform-team"
    team        = "platform"
    cost_center = "1234"
  }

}
