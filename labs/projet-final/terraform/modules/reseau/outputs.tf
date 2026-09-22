output "network_id" {
  description = "Identifiant du VPC"
  value       = google_compute_network.vpc.id
}

output "network_name" {
  description = "Nom du VPC"
  value       = google_compute_network.vpc.name
}

output "subnetwork_id" {
  description = "Identifiant du sous-reseau a transmettre aux autres modules"
  value       = google_compute_subnetwork.subnet.id
}

output "subnetwork_name" {
  description = "Nom du sous-reseau"
  value       = google_compute_subnetwork.subnet.name
}