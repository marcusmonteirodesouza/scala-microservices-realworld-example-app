variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "region" {
  type        = string
  description = "The default GCP region for the created resources."
}

variable "gke_primary_ip_cidr_range" {
  type        = string
  description = "The IP CIDR range reserved for the GKE primary cluster."
}

variable "db_instance_tier" {
  type        = string
  description = "The machine type to use."
}

variable "users_service_initdb_bucket" {
  type        = string
  description = "The name of the GCS bucket where the initdb.sql file is stored."
}

variable "users_service_replicas" {
  type        = number
  description = "The number of desired Users Service pods."
}

variable "users_service_image" {
  type        = string
  description = "The name Users Service container image."
}

variable "users_service_database_num_threads" {
  type        = number
  description = "The number of threads used by the Users Service app connection pool."
}

variable "users_service_database_min_connections" {
  type        = number
  description = "The minimum number of connections in the Users Service app connection pool."
}

variable "users_service_database_max_connections" {
  type        = number
  description = "The maximum number of connections in the Users Service app connection pool."
}

variable "users_service_database_queue_size" {
  type        = number
  description = "The Users Service app database connection queue size."
}

variable "users_service_hard_termination_deadline_duration_seconds" {
  type        = number
  description = "The timeout in seconds before the shutting down Users Service server forcefully terminates."
}

variable "users_service_jwt_issuer" {
  type        = string
  description = "The JWT token issuer."
}

variable "users_service_jwt_seconds_to_expire" {
  type        = number
  description = "The number of seconds a newly issued JWT token is valid for."
}
