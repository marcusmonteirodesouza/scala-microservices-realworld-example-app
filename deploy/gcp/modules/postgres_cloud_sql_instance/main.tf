data "google_compute_network" "network" {
  name = var.network
}

resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "random_id" "database_instance_suffix" {
  byte_length = 4
}

resource "google_compute_global_address" "main" {
  name          = "${local.instance_name}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network
}

resource "google_project_service" "servicenetworking" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.main.name]

  depends_on = [
    google_project_service.servicenetworking
  ]
}

resource "google_sql_database_instance" "main" {
  name             = local.instance_name
  database_version = "POSTGRES_14"

  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.network.id
    }
  }

  depends_on = [
    google_project_service.sqladmin,
    google_service_networking_connection.private_vpc_connection
  ]
}

resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "random_password" "admin_user" {
  length = 14
}

resource "random_password" "admin_password" {
  length = 14
}

resource "google_sql_user" "admin" {
  name     = random_password.admin_user.result
  instance = google_sql_database_instance.main.name
  password = random_password.admin_password.result
}

resource "google_secret_manager_secret" "admin_user" {
  secret_id = "${google_sql_database_instance.main.name}-admin-user"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secretmanager
  ]
}

resource "google_secret_manager_secret_version" "admin_user" {
  secret = google_secret_manager_secret.admin_user.id

  secret_data = random_password.admin_user.result
}

resource "google_secret_manager_secret" "admin_password" {
  secret_id = "${google_sql_database_instance.main.name}-admin-password"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secretmanager
  ]
}

resource "google_secret_manager_secret_version" "admin_password" {
  secret = google_secret_manager_secret.admin_password.id

  secret_data = random_password.admin_password.result
}
