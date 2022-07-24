output "name" {
  value = google_sql_database_instance.main.name
}

output "sa_email" {
  value = google_sql_database_instance.main.service_account_email_address
}

output "admin_user_secret" {
  value     = google_secret_manager_secret.admin_user.secret_id
  sensitive = true
}

output "admin_password_secret" {
  value     = google_secret_manager_secret.admin_password.secret_id
  sensitive = true
}
