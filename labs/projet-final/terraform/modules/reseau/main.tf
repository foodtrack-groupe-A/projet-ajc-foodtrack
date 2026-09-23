locals {
  pods_range_name     = "foodtrack-${var.equipe}-pods"
  services_range_name = "foodtrack-${var.equipe}-services"
}

resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "foodtrack-${var.equipe}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "foodtrack-${var.equipe}-subnet"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "foodtrack-${var.equipe}-pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "foodtrack-${var.equipe}-services"
    ip_cidr_range = var.services_cidr
  }
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

resource "google_compute_firewall" "allow_ping_test" {
  name    = "foodtrack-${var.equipe}-allow-ping-test"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}