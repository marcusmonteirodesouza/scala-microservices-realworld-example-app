resource "google_container_cluster" "gke_autopilot" {
  name       = var.name
  location   = var.location
  network    = var.network
  subnetwork = var.subnetwork

  enable_autopilot = true
  # See https://github.com/hashicorp/terraform-provider-google/issues/10782#issuecomment-1024488630
  ip_allocation_policy {
  }
}
