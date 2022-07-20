variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "region" {
  type        = string
  description = "The default GCP region for the created resources."
}

variable "gke_primary_ip_cidr_range" {
  type        = string
  description = "The IP CIDR range reserved for the GKE primary cluster."
}

variable "db_instance_tier" {
  type        = string
  description = "The machine type to use."
}
