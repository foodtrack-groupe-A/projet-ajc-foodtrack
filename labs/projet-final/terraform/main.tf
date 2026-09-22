module "reseau" {
  source = "./modules/reseau"

  project_id = var.project_id
  equipe = var.equipe
  region = var.region
  subnet_cidr = var.subnet_cidr
  ssh_source_cidr = var.ssh_source_cidr
}

module "stockage" {
  source = "./modules/stockage"

  project_id = var.project_id
  equipe = var.equipe
  region = var.region
}

module "compute" {
  source = "./modules/compute"

  equipe = var.equipe
  zone = var.zone
  network_id = var.network_id
  subnetwork_id = var.subnetwork_id
  pods_range_name = var.pods_range_name
  services_range_name = var.services_range_name
  master_cidr = var.master_cidr
  node_count = var.node_count
  machine_type = var.machine_type
  service_account_email = var.service_account_email
  environment = var.environment
}