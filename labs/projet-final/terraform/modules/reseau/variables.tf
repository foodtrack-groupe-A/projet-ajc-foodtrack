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

variable "subnet_cidr" {
  description = "Plage IPv4 principale du sous-reseau"
  type        = string
}

variable "ssh_source_cidr" {
  description = "Adresse IPv4 publique autorisee pour la connexion du bastion en SSH"
  type        = string
}