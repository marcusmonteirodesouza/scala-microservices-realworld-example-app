variable "database_instance" {
  type        = string
  description = "The name of the Cloud SQL instance."
}

variable "database_instance_sa_email" {
  type        = string
  description = "The email address of the Cloud SQL instance Service Account."
}

variable "database_port" {
  type        = number
  description = "The port the database instance is listening on."
}

variable "database_user_secret" {
  type        = string
  description = "The secret where the database user value is stored."
  sensitive   = true
}

variable "database_password_secret" {
  type        = string
  description = "The secret where the database password value is stored."
  sensitive   = true
}

variable "initdb_bucket" {
  type        = string
  description = "The name of the GCS bucket where the initdb.sql file is stored."
}

variable "replicas" {
  type        = number
  description = "The number of desired pods."
}

variable "image" {
  type        = string
  description = "The container image URL."
}

variable "container_host" {
  default     = "0.0.0.0"
  description = "The app's host on the container."
}

variable "container_port" {
  type        = number
  description = "The app's port on the container."
}

variable "database_num_threads" {
  type        = number
  description = "The number of threads used by the app's connection pool."
}

variable "database_min_connections" {
  type        = number
  description = "The minimum number of connections in the app's connection pool."
}

variable "database_max_connections" {
  type        = number
  description = "The maximum number of connections in the app's connection pool."
}

variable "database_queue_size" {
  type        = number
  description = "The database connection queue size."
}

variable "hard_termination_deadline_duration_seconds" {
  type        = number
  description = "The timeout in seconds before the shutting down app server forcefully terminates."
}

variable "jwt_issuer" {
  type        = string
  description = "The JWT token issuer."
}

variable "jwt_seconds_to_expire" {
  type        = number
  description = "The number of seconds a newly issued JWT token is valid for."
}
