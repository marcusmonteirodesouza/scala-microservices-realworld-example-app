variable "billing_account" {
  type        = string
  description = "The alphanumeric ID of the billing account this project belongs to."
}

variable "folder_id" {
  type        = string
  description = "The numeric ID of the folder this project should be created under."
}

variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "region" {
  type        = string
  description = "The default GCP region for the created resources."
}

variable "users_service_repo_owner" {
  type        = string
  description = "The Users Service Github repository owner."
}

variable "users_service_repo_name" {
  type        = string
  description = "The Users Service Github repository name."
}

variable "users_service_branch_name" {
  default     = "main"
  description = "The Users Service Github branch name."
}