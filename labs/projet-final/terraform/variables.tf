variable "project_id" {
  description = "Identifiant du projet Google Cloud de l'equipe"
  type        = string
}

variable "equipe" {
  description = "Lettre du groupe utilisee dans les ressources"
  type        = string
}

variable "region" {
  description = "Region Google Cloud attribuee"
  type        = string
}

variable "zone" {
  type        = string
  description = "Zone GCP d'hébergement du cluster zonal"
  default     = "europe-west8-a"
}

variable "subnet_cidr" {
  description = "Plage IPv4 principale du sous-reseau"
  type        = string
}

variable "ssh_source_cidr" {
  description = "Adresse IPv4 publique autorisee pour la connexion du bastion en SSH"
  type        = string
}

variable "network_id" {
  type        = string
  description = "ID ou nom du VPC"
}

variable "subnetwork_id" {
  type        = string
  description = "ID ou nom du sous-réseau"
}

variable "pods_range_name" {
  type        = string
  description = "Nom de la plage d'IP secondaire pour les Pods"
}

variable "services_range_name" {
  type        = string
  description = "Nom de la plage d'IP secondaire pour les Services"
}

variable "master_cidr" {
  type        = string
  description = "Plage CIDR /28 réservée au Master GKE"
  default     = "172.16.0.0/28"
}

variable "node_count" {
  type        = number
  description = "Nombre de nœuds dans le node pool"
  default     = 1
}

variable "machine_type" {
  type        = string
  description = "Type de machine pour les nœuds"
  default     = "e2-medium"
}

variable "service_account_email" {
  type        = string
  description = "Email du Service Account attaché aux nœuds"
}

variable "environment" {
  type        = string
  description = "Environnement (dev, staging, prod)"
  default     = "dev"
}