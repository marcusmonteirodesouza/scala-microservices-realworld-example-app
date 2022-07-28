resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "${var.cluster_name}-ingress"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = var.users_service_service_name
              port {
                number = var.users_service_service_port
              }
            }
          }

          path = "/users"
        }
        path {
          backend {
            service {
              name = var.users_service_service_name
              port {
                number = var.users_service_service_port
              }
            }
          }

          path = "/users/*"
        }
        path {
          backend {
            service {
              name = var.users_service_service_name
              port {
                number = var.users_service_service_port
              }
            }
          }

          path = "/user"
        }
        path {
          backend {
            service {
              name = var.users_service_service_name
              port {
                number = var.users_service_service_port
              }
            }
          }

          path = "/user/*"
        }
      }
    }
  }
}
