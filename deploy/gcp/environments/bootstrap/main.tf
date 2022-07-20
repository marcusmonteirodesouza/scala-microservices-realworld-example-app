resource "google_project" "realworld_example" {
  name                = var.project_id
  project_id          = var.project_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

# Terraform state bucket
resource "random_pet" "tfstate_bucket" {
}

resource "google_storage_bucket" "tfstate" {
  project  = google_project.realworld_example.project_id
  name     = random_pet.tfstate_bucket.id
  location = var.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

# Enable APIs

resource "google_project_service" "cloudbuild" {
  project            = google_project.realworld_example.project_id
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

# Users service setup

## Artifact registry
resource "google_project_service" "artifactregistry" {
  project            = google_project.realworld_example.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "users_service" {
  provider = google-beta

  project       = google_project.realworld_example.project_id
  location      = var.region
  repository_id = "users-service-repository"
  description   = "Users Service Repository"
  format        = "DOCKER"

  depends_on = [
    google_project_service.artifactregistry
  ]
}

## Storage Buckets
resource "random_pet" "users_service_init_db_bucket" {
}

resource "google_storage_bucket" "users_service_init_db" {
  project  = google_project.realworld_example.project_id
  name     = random_pet.users_service_init_db_bucket.id
  location = var.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

## Cloud Build triggers 

resource "google_cloudbuild_trigger" "users_service_cloud_build_trigger" {
  project     = google_project.realworld_example.project_id
  description = "GitHub Repository Trigger ${var.users_service_repo_owner}/${var.users_service_repo_name} (${var.users_service_branch_name})"

  github {
    owner = var.users_service_repo_owner
    name  = var.users_service_repo_name
    push {
      branch = var.users_service_branch_name
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    "_LOCATION"      = var.region
    "_REPOSITORY"    = google_artifact_registry_repository.users_service.name
    "_IMAGE"         = "users-service"
    "_INITDB_BUCKET" = google_storage_bucket.users_service_init_db.url
  }

  depends_on = [
    google_project_service.cloudbuild,
  ]
}
