resource "google_storage_bucket" "backups" {
  project                     = var.project_id
  name                        = "foodtrack-${var.equipe}-backups-${var.project_id}"
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = false
}

resource "google_storage_bucket" "logs" {
  project                     = var.project_id
  name                        = "foodtrack-${var.equipe}-logs-${var.project_id}"
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  force_destroy               = false
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}

resource "google_artifact_registry_repository" "docker" {
  project       = var.project_id
  location      = var.region
  repository_id = "foodtrack-${var.equipe}-docker"
  description   = "Images Docker de l'application FoodTrack"
  format        = "DOCKER"

  labels = {
    equipe      = var.equipe
    application = "foodtrack"
  }
}