# ==========================================
# ENVIRONNEMENT : TEST / STAGING
# ==========================================

# --- Paramètres Globaux ---
project_id = "form-gke-eleve01-4621" # ID du projet GCP de Test
equipe     = "a"
region     = "europe-west8" # Milan
zone       = "europe-west8-b"


# --- Paramètres Réseau ---
subnet_cidr     = "10.0.0.0/20"
pods_cidr       = "10.4.0.0/14"
services_cidr   = "10.8.0.0/20"
master_cidr     = "172.16.0.0/28"
ssh_source_cidr = "35.235.240.0/20"

# --- Paramètres Compute / GKE ---
node_count            = 2 # 2 nœuds pour tester la haute disponibilité
node_disk_size_gb     = 50
machine_type          = "e2-standard-2"
bastion_machine_type  = "e2-micro"
service_account_email = "618189904543-compute@developer.gserviceaccount.com"

# --- Configuration GitHub / CI-CD ---
github_owner = "foodtrack-groupe-A"
github_repo  = "projet-ajc-foodtrack"