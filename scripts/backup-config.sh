#!/usr/bin/env bash
set -euo pipefail

# Configuration
BUCKET_NAME="gs://form-gke-eleve01-4621-tfstate" # Remplace par le nom exact de ton bucket de sauvegarde
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/tmp/foodtrack_backup_${DATE}"
ARCHIVE_NAME="backup_foodtrack_${DATE}.tar.gz"

echo "=== Création du dossier temporaire de sauvegarde ==="
mkdir -p "$BACKUP_DIR"

echo "=== Exportation des configurations Kubernetes ==="
kubectl get all --all-namespaces -o yaml > "$BACKUP_DIR/k8s_all_resources.yaml"
kubectl get configmap --all-namespaces -o yaml > "$BACKUP_DIR/k8s_configmaps.yaml"

echo "=== Compression de l'archive ==="
tar -czf "/tmp/$ARCHIVE_NAME" -C "$BACKUP_DIR" .

echo "=== Envoi vers le bucket Google Cloud Storage ==="
gcloud storage cp "/tmp/$ARCHIVE_NAME" "${BUCKET_NAME}/backups/${ARCHIVE_NAME}"

echo "=== Nettoyage des fichiers temporaires ==="
rm -rf "$BACKUP_DIR" "/tmp/$ARCHIVE_NAME"

echo "Sauvegarde terminée et envoyée avec succès sur ${BUCKET_NAME}/backups/${ARCHIVE_NAME}"