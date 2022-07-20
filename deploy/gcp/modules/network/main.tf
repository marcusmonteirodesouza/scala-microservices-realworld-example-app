resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_primary" {
  name          = "gke-primary-cluster-subnetwork"
  ip_cidr_range = var.gke_primary_ip_cidr_range
  network       = google_compute_network.vpc_network.id
}
