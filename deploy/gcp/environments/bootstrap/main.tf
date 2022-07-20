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

# Used to process Artifact Registry events. See https://cloud.google.com/artifact-registry/docs/configure-notifications
resource "google_pubsub_topic" "gcr" {
  project = google_project.realworld_example.project_id
  name    = "gcr"
}

# Cloud Build Trigger
resource "google_cloudbuild_trigger" "realworld_app" {
  project     = google_project.realworld_example.project_id
  description = "GitHub Repository Trigger ${var.repo_owner}/${var.repo_name} (${var.branch_name})"

  pubsub_config {
    topic = google_pubsub_topic.gcr.id
  }

  source_to_build {
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    ref       = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = "https://github.com/${var.repo_owner}/${var.repo_name}"
    revision  = "refs/heads/${var.branch_name}"
    repo_type = "GITHUB"
  }

  substitutions = {
    _ENV            = var.environment
    _TFSTATE_BUCKET = google_storage_bucket.tfstate.name
    _REGION         = var.region
  }
}

resource "null_resource" "submit_community_builders" {
  provisioner "local-exec" {
    command     = "./submit-community-builders.sh ${google_project.realworld_example.project_id}"
    working_dir = "${path.module}/scripts"
  }
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
resource "google_cloudbuild_trigger" "users_service" {
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
