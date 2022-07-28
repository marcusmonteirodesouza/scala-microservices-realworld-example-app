variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "users_service_service_name" {
  type        = string
  description = "The name of the of the Users Service kubernetes Service."
}

variable "users_service_service_port" {
  type        = number
  description = "The port of the of the Users Service kubernetes Service."
}
