# ==========================================
# ENVIRONNEMENT : TEST / STAGING
# ==========================================

# --- Paramètres Globaux ---
project_id  = "foodtrack-test-project-id" # ID du projet GCP de Test
equipe      = "a"
region      = "europe-west8"              # Paris
zone        = "europe-west8-b"
environment = "test"

# --- Paramètres Réseau ---
subnet_cidr     = "10.10.0.0/20"
ssh_source_cidr = "10.0.0.0/8"            # Restreint au réseau d'entreprise / VPN

# --- Paramètres Compute / GKE ---
master_cidr           = "172.16.1.0/28"   # Plage CIDR dédiée au master de Test (évite les chevauchements)
node_count            = 2                 # 2 nœuds pour tester la haute disponibilité
node_disk_size_gb     = 50
machine_type          = "e2-standard-2"
bastion_machine_type  = "e2-micro"
service_account_email = "618189904543-compute@developer.gserviceaccount.com"

# --- Configuration GitHub / CI-CD ---
github_owner = "diogeek"
github_repo  = "projet-ajc-foodtrack"