terraform {
  required_providers {
    google = {
      version = ">= 4.28.0"
      source  = "hashicorp/google"
    }
    google-beta = {
      version = ">= 4.28.0"
      source  = "hashicorp/google-beta"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.17.0"
    }
    kubernetes = {
      version = ">= 2.12.1"
      source  = "hashicorp/kubernetes"
    }
  }
}
