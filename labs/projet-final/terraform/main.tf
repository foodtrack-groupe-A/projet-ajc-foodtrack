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