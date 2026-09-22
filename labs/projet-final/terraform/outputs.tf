output "network_id" {
  value = module.reseau.network_id
}

output "subnetwork_id" {
  value = module.reseau.subnetwork_id
}

output "cluster_name" {
  value = module.compute.cluster_name
}

output "cluster_endpoint" {
  value = module.compute.cluster_endpoint
}

output "backups_bucket_url" {
  value = module.stockage.backups_bucket_url
}

output "logs_bucket_url" {
  value = module.stockage.logs_bucket_url
}