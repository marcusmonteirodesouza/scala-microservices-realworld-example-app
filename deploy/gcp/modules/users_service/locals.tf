locals {
  kubernetes_namespace = kubernetes_namespace.users_service.metadata.0.name
}
