output "backups_bucket_name" {
  description = "Nom du bucket contenant les sauvegardes"
  value       = google_storage_bucket.backups.name
}

output "backups_bucket_url" {
  description = "URL GCS du bucket contenant les sauvegardes"
  value       = google_storage_bucket.backups.url
}

output "logs_bucket_name" {
  description = "Nom du bucket contenant les exports de journaux"
  value       = google_storage_bucket.logs.name
}

output "logs_bucket_url" {
  description = "URL GCS du bucket contenant les exports de journaux"
  value       = google_storage_bucket.logs.url
}