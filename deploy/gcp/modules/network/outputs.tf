output "name" {
  value = google_compute_network.vpc_network.name
}

output "gke_primary_subnetwork" {
  value = google_compute_subnetwork.gke_primary.name
}
