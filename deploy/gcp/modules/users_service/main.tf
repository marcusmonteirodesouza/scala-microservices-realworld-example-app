# Database

data "google_project" "project" {
}

data "google_storage_bucket" "initdb" {
  name = var.initdb_bucket
}

data "docker_registry_image" "users_service" {
  name = var.image
}

data "google_sql_database_instance" "instance" {
  name = var.database_instance
}

data "google_secret_manager_secret_version" "database_user" {
  secret = var.database_user_secret
}

data "google_secret_manager_secret_version" "database_password" {
  secret = var.database_password_secret
}

resource "google_sql_database" "database" {
  name     = "users"
  instance = var.database_instance
}

resource "google_storage_bucket_iam_member" "database_instance_sa_initdb_bucket_object_viewer" {
  bucket = var.initdb_bucket
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.database_instance_sa_email}"
}

# TODO(Marcus): research patterns for handling migrations on the cloud
resource "null_resource" "initdb_import_sql" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "gcloud sql import sql ${var.database_instance} ${data.google_storage_bucket.initdb.url}/initdb.sql --project=${data.google_project.project.project_id} --database=${google_sql_database.database.name} --quiet"
  }

  depends_on = [
    google_storage_bucket_iam_member.database_instance_sa_initdb_bucket_object_viewer
  ]
}

# Kubernetes Deployment
resource "random_password" "jwt_secret_key" {
  length = 64
}

resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_secret_manager_secret" "jwt_secret_key" {
  secret_id = "users-service-jwt-key"

  replication {
    automatic = true
  }

  depends_on = [
    google_project_service.secretmanager
  ]
}

resource "google_secret_manager_secret_version" "jwt_secret_key" {
  secret = google_secret_manager_secret.jwt_secret_key.id

  secret_data = random_password.jwt_secret_key.result
}

resource "kubernetes_namespace" "users_service" {
  metadata {
    name = "users-service-namespace"
  }
}

resource "kubernetes_secret" "users_service" {
  metadata {
    namespace = local.kubernetes_namespace
    name      = "users-service-secret"
  }

  data = {
    DB_HOST        = data.google_sql_database_instance.instance.ip_address.0.ip_address
    DB_PORT        = var.database_port
    DB_NAME        = google_sql_database.database.name
    DB_USER        = data.google_secret_manager_secret_version.database_user.secret_data
    DB_PASSWORD    = data.google_secret_manager_secret_version.database_password.secret_data
    JWT_SECRET_KEY = google_secret_manager_secret_version.jwt_secret_key.secret_data
  }
}

resource "kubernetes_deployment" "users_service_deployment" {
  metadata {
    namespace = local.kubernetes_namespace
    name      = "users-service-deployment"
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "users-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "users-service"
        }
      }

      spec {
        container {
          image = "${var.image}@${data.docker_registry_image.users_service.sha256_digest}"
          name  = "users-service-pod"

          liveness_probe {
            http_get {
              path = "/healthcheck"
              port = var.container_port
            }
          }
          env {
            name  = "DB_NUM_THREADS"
            value = var.database_num_threads
          }
          env {
            name  = "DB_MIN_CONNECTIONS"
            value = var.database_min_connections
          }
          env {
            name  = "DB_MAX_CONNECTIONS"
            value = var.database_max_connections
          }
          env {
            name  = "DB_QUEUE_SIZE"
            value = var.database_queue_size
          }
          env {
            name  = "HOST"
            value = var.container_host
          }
          env {
            name  = "PORT"
            value = var.container_port
          }
          env {
            name  = "HARD_TERMINATION_DEADLINE_DURATION_SECONDS"
            value = var.hard_termination_deadline_duration_seconds
          }
          env {
            name  = "JWT_ISSUER"
            value = var.jwt_issuer
          }
          env {
            name  = "JWT_SECONDS_TO_EXPIRE"
            value = var.jwt_seconds_to_expire
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.users_service.metadata.0.name
            }
          }
        }
      }
    }
  }
}
