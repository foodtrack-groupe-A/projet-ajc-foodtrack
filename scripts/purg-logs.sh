#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="gs://form-gke-eleve01-4621-tfstate" # Remplace par ton bucket si les logs y sont exportés
RETENTION_DAYS=30

echo "=== Purge des fichiers de logs anciens dans Google Cloud Storage (> ${RETENTION_DAYS} jours) ==="

# Recherche et suppression des objets plus vieux que 30 jours dans le dossier logs/
# gcloud storage/gsutil offre une gestion de cycle de vie, mais ce script force le nettoyage
OLD_DATE=$(date -d "${RETENTION_DAYS} days ago" +%Y-%m-%d)

echo "Suppression des archives de logs antérieures à : $OLD_DATE"

# Utilisation d'une commande idempotent gcloud storage
gcloud storage rm "${BUCKET_NAME}/logs/**" --older-than="${RETENTION_DAYS}d" --quiet || {
  echo "Aucun fichier à purger ou dossier inexistant."
}

echo "Purge des logs terminée."