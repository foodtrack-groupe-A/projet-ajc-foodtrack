# ==========================================
# ENVIRONNEMENT : PRODUCTION
# ==========================================

# --- Paramètres Globaux ---
project_id  = "form-gke-eleve01-4621" # ID du projet GCP de Production
equipe      = "a"
region      = "europe-west8" # Milan
zone        = "europe-west8-a"


# --- Paramètres Réseau ---
subnet_cidr   = "10.0.0.0/20"
pods_cidr     = "10.4.0.0/14"
services_cidr = "10.8.0.0/20"
master_cidr   = "172.16.0.0/28"
ssh_source_cidr = "35.235.240.0/20"

# --- Paramètres Compute / GKE ---
node_count            = 2               # 3 nœuds minimum pour le quorum et la tolérance aux pannes
node_disk_size_gb     = 50
machine_type          = "e2-standard-2"
bastion_machine_type  = "e2-micro"

# --- Configuration GitHub / CI-CD ---
github_owner = "diogeek"
github_repo  = "projet-ajc-foodtrack"