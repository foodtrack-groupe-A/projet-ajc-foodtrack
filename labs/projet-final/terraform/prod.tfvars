# ==========================================
# ENVIRONNEMENT : PRODUCTION
# ==========================================

# --- Paramètres Globaux ---
project_id  = "foodtrack-prod-project-id" # ID du projet GCP de Production
equipe      = "a"
region      = "europe-west9"              # Paris
zone        = "europe-west9-a"
environment = "prod"

# --- Paramètres Réseau ---
subnet_cidr     = "10.20.0.0/20"
ssh_source_cidr = "192.168.1.50/32"       # Restreint uniquement à l'IP du Bastion / VPN d'exploitation

# --- Paramètres Compute / GKE ---
master_cidr           = "172.16.2.0/28"   # Plage CIDR dédiée au master de Prod
node_count            = 3                 # 3 nœuds minimum pour le quorum et la tolérance aux pannes
node_disk_size_gb     = 50
machine_type          = "e2-standard-2"
bastion_machine_type  = "e2-micro"
service_account_email = "618189904543-compute@developer.gserviceaccount.com"

# --- Configuration GitHub / CI-CD ---
github_owner = "diogeek"
github_repo  = "projet-ajc-foodtrack"