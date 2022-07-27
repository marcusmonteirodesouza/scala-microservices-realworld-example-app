locals {
  cloudbuild_sa_email                                      = "${google_project.realworld_example.number}@cloudbuild.gserviceaccount.com"
  users_service_replicas                                   = 3
  users_service_image_name                                 = "users-service"
  users_service_image                                      = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.users_service.name}/${local.users_service_image_name}"
  users_service_database_num_threads                       = 10
  users_service_database_min_connections                   = local.users_service_database_num_threads
  users_service_database_max_connections                   = local.users_service_database_num_threads * 5
  users_service_database_queue_size                        = 1000
  users_service_hard_termination_deadline_duration_seconds = 5
  users_service_jwt_issuer                                 = "scala-microservices-realworld-example-app"
  users_service_jwt_seconds_to_expire                      = 86400
}
