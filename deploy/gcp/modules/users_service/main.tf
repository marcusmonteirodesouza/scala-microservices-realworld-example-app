data "google_project" "project" {
}

data "google_storage_bucket" "initdb" {
  name = var.users_service_initdb_bucket
}

resource "google_sql_database" "database" {
  name     = "users"
  instance = var.database_instance
}

resource "google_storage_bucket_iam_member" "database_instance_sa_initdb_bucket_object_viewer" {
  bucket = var.users_service_initdb_bucket
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
