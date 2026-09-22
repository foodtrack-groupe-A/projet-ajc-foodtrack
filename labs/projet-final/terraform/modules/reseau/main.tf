resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "foodtrack-${var.equipe}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  project                  = var.project_id
  name                     = "foodtrack-${var.equipe}-subnet"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "foodtrack-${var.equipe}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = "foodtrack-${var.equipe}-nat"
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "allow_ssh_bastion" {
  project = var.project_id
  name    = "foodtrack-${var.equipe}-allow-ssh-bastion"
  network = google_compute_network.vpc.id

  direction = "INGRESS"
  priority  = 1000

  source_ranges = [var.ssh_source_cidr]
  target_tags   = ["foodtrack-${var.equipe}-bastion"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}