resource "google_sql_database" "database" {
  name     = "users"
  instance = var.database_instance
}
