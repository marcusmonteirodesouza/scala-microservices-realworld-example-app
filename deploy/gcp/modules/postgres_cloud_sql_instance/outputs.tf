output "name" {
  value = google_sql_database_instance.main.name
}

output "admin_user_secret" {
  value     = google_secret_manager_secret.admin_user.secret_id
  sensitive = true
}

output "admin_password_secret" {
  value     = google_secret_manager_secret.admin_password.secret_id
  sensitive = true
}
