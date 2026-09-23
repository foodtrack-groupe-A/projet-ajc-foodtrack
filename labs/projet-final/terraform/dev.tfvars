# ==========================================
# ENVIRONNEMENT : DEVELOPPEMENT
# ==========================================

# --- Paramètres Globaux ---
project_id  = "ton-projet-gcp-id"
equipe      = "a"
region      = "europe-west8"
zone        = "europe-west8-b"
environment = "dev"

# --- Paramètres Réseau ---
subnet_cidr     = "10.0.0.0/20"
ssh_source_cidr = "0.0.0.0/0"

# --- Paramètres Compute / GKE ---
master_cidr           = "172.16.0.0/28"
node_count            = 1
node_disk_size_gb     = 50
machine_type          = "e2-standard-2"
bastion_machine_type  = "e2-micro"
service_account_email = "sa-gke-node@ton-projet-gcp-id.iam.gserviceaccount.com"

# --- Configuration GitHub / CI-CD ---
github_owner = "diogeek"
github_repo  = "projet-ajc-foodtrack"