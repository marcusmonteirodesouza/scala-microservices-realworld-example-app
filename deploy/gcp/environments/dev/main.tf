provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source = "../../modules/network"

  gke_primary_ip_cidr_range = var.gke_primary_ip_cidr_range
}

module "postgres_cloud_sql_instance" {
  source = "../../modules/postgres_cloud_sql_instance"

  tier = var.db_instance_tier
}

module "gke_autopilot_primary_cluster" {
  source = "../../modules/gke_autopilot"

  name       = "gke-autopilot-primary-cluster"
  location   = var.region
  network    = module.network.name
  subnetwork = module.network.gke_primary_subnetwork
}

module "users_service" {
  source = "../../modules/users_service"

  database_instance = module.postgres_cloud_sql_instance.name
}
