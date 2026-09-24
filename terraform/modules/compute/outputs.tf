output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "Nom du cluster GKE"
}

output "cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "IP publique du plan de contrôle Kubernetes"
}

output "ca_certificate" {
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  description = "Certificat CA du cluster pour la configuration de kubectl"
  sensitive   = true
}

output "bastion_name" {
  description = "Nom de l'instance bastion"
  value       = google_compute_instance.bastion.name
}

output "bastion_internal_ip" {
  description = "Adresse IP privée du bastion"
  value       = google_compute_instance.bastion.network_interface[0].network_ip
}