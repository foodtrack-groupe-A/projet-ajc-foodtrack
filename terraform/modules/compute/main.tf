resource "google_container_cluster" "primary" {
  name     = "foodtrack-${var.equipe}-cluster" # nom du cluster, convention par lettre d'equipe
  location = var.zone                          # cluster zonal, pas regional (contrainte imposee)

  remove_default_node_pool = true # on supprime le pool cree automatiquement par GKE
  initial_node_count       = 1    # exige par l API meme si le pool est detruit juste apres

  network    = var.network_id    # rattachement au VPC du module reseau
  subnetwork = var.subnetwork_id # rattachement au sous-reseau du module reseau

  ip_allocation_policy {                                    # active le mode VPC natif
    cluster_secondary_range_name  = var.pods_range_name     # plage secondaire dediee aux pods
    services_secondary_range_name = var.services_range_name # plage secondaire dediee aux services
  }

  private_cluster_config {                    # configuration des noeuds prives
    enable_private_nodes    = true            # aucun noeud n'a d'IP publique
    enable_private_endpoint = false           # le plan de controle reste joignable en public
    master_ipv4_cidr_block  = var.master_cidr # plage IP interne reservee au plan de controle
  }

  # master_authorized_networks_config : EN ATTENTE (cf. discussion Lead livraison)

  logging_service    = "logging.googleapis.com/kubernetes"    # active Cloud Logging sur les composants systeme
  monitoring_service = "monitoring.googleapis.com/kubernetes" # active Cloud Monitoring sur les composants systeme

  deletion_protection = false # false pendant le projet, a repasser a true avant la demo si besoin
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "foodtrack-${var.equipe}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_type    = "pd-standard"
    disk_size_gb = var.node_disk_size_gb # Utilisation de la variable pour le disque GKE

    # Compte de service dédié
    service_account = var.service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      equipe      = var.equipe
      environment = var.environment
    }

    tags = ["gke-node", "foodtrack-${var.equipe}"]
  }
}

# --- INSTANCE BASTION ---
resource "google_compute_instance" "bastion" {
  name         = "foodtrack-${var.equipe}-bastion"
  machine_type = var.bastion_machine_type
  zone         = var.zone

  allow_stopping_for_update = true

  tags = ["bastion", "foodtrack-${var.equipe}-bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnetwork_id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}