output "service_name" {
  value = kubernetes_service.users_service_service.metadata.0.name
}

output "service_port" {
  value = kubernetes_service.users_service_service.spec.0.port.0.port
}
