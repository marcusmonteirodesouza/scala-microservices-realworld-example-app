data "google_client_config" "default" {
}

data "google_container_cluster" "gke_autopilot_primary_cluster" {
  name     = module.gke_autopilot_primary_cluster.name
  location = var.region
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "docker" {
  registry_auth {
    address  = "${var.region}-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke_autopilot_primary_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke_autopilot_primary_cluster.master_auth[0].cluster_ca_certificate)
}

module "network" {
  source = "../../modules/network"

  gke_primary_ip_cidr_range = var.gke_primary_ip_cidr_range
}

module "postgres_cloud_sql_instance" {
  source = "../../modules/postgres_cloud_sql_instance"

  network = module.network.name
  tier    = var.db_instance_tier
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

  database_instance                          = module.postgres_cloud_sql_instance.name
  database_instance_sa_email                 = module.postgres_cloud_sql_instance.sa_email
  database_port                              = module.postgres_cloud_sql_instance.port
  database_user_secret                       = module.postgres_cloud_sql_instance.admin_user_secret
  database_password_secret                   = module.postgres_cloud_sql_instance.admin_password_secret
  initdb_bucket                              = var.users_service_initdb_bucket
  replicas                                   = var.users_service_replicas
  image                                      = var.users_service_image
  container_port                             = 8080
  database_num_threads                       = var.users_service_database_num_threads
  database_min_connections                   = var.users_service_database_min_connections
  database_max_connections                   = var.users_service_database_max_connections
  database_queue_size                        = var.users_service_database_queue_size
  hard_termination_deadline_duration_seconds = var.users_service_hard_termination_deadline_duration_seconds
  jwt_issuer                                 = var.users_service_jwt_issuer
  jwt_seconds_to_expire                      = var.users_service_jwt_seconds_to_expire
}
