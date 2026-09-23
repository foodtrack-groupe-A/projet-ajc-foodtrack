module "reseau" {
  source = "./modules/reseau"

  project_id      = var.project_id
  equipe          = var.equipe
  region          = var.region
  subnet_cidr     = var.subnet_cidr
  pods_cidr       = var.pods_cidr
  services_cidr   = var.services_cidr
  ssh_source_cidr = var.ssh_source_cidr
}

module "stockage" {
  source = "./modules/stockage"

  project_id = var.project_id
  equipe     = var.equipe
  region     = var.region
}

module "compute" {
  source = "./modules/compute"

  equipe = var.equipe
  zone   = var.zone

  # --- LIAISON DYNAMIQUE AVEC LES OUTPUTS RÉSEAU ---
  network_id          = module.reseau.network_id
  subnetwork_id       = module.reseau.subnetwork_id
  pods_range_name     = module.reseau.pods_range_name
  services_range_name = module.reseau.services_range_name

  # --- CONFIGURATION GKE ---
  master_cidr           = var.master_cidr
  node_count            = var.node_count
  machine_type          = var.machine_type
  node_disk_size_gb     = var.node_disk_size_gb
  bastion_machine_type  = var.bastion_machine_type
  service_account_email = var.service_account_email
  environment           = var.environment

  depends_on = [module.reseau]
}