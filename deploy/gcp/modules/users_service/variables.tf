variable "database_instance" {
  type        = string
  description = "The name of the Cloud SQL instance."
}

variable "database_instance_sa_email" {
  type        = string
  description = "The email address of the Cloud SQL instance Service Account."
}

variable "users_service_initdb_bucket" {
  type        = string
  description = "The name of the GCS bucket where the initdb.sql file is stored."
}
