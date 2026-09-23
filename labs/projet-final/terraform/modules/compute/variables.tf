variable "equipe" {
  type        = string
  description = "Lettre ou nom de l'équipe (ex: a, b, c)"
}

variable "zone" {
  type        = string
  description = "Zone GCP d'hébergement du cluster zonal"
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

variable "node_disk_size_gb" {
  type        = number
  description = "Taille du disque pour chaque nœud du cluster GKE en Go"
}

variable "bastion_machine_type" {
  type        = string
  description = "Type de machine de l'instance Bastion"
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