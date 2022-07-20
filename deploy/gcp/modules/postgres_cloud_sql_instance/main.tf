resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "random_id" "database_instance_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance-${random_id.database_instance_suffix.hex}"
  database_version = "POSTGRES_14"

  settings {
    tier = var.tier
  }

  depends_on = [
    google_project_service.sqladmin,
  ]
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
