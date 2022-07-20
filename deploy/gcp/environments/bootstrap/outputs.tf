output "tfstate_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "users_service_artifact_registry_repository" {
  value = google_artifact_registry_repository.users_service.name
}

output "users_service_initdb_bucket_url" {
  value = google_storage_bucket.users_service_init_db.url
}
