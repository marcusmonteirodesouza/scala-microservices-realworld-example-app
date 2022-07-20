provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

module "postgres_cloud_sql_instance" {
  source = "../../modules/postgres_cloud_sql_instance"

  tier = var.db_instance_tier
}
