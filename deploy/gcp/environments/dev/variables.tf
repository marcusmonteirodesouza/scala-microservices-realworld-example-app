variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "region" {
  type        = string
  description = "The default GCP region for the created resources."
}

variable "db_instance_tier" {
  type        = string
  description = "The machine type to use."
}
