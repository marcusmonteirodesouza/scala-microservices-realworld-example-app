output "service_name" {
  value = kubernetes_service.users_service_service.metadata.0.name
}
