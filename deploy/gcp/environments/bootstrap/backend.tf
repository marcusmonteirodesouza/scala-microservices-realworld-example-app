terraform {
  backend "gcs" {
    bucket = "diverse-blowfish"
    prefix = "bootstrap"
  }
}
