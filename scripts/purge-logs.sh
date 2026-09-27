#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="gs://foodtrack-a-logs-form-gke-eleve01-4621"
RETENTION_DAYS=30
CUTOFF=$(date -d "${RETENTION_DAYS} days ago" +%s)

echo "=== Purge des logs de plus de ${RETENTION_DAYS} jours dans ${BUCKET_NAME}/logs/ ==="

mapfile -t LISTING < <(gcloud storage ls -l "${BUCKET_NAME}/logs/**" 2>/dev/null || true)

DELETED=0
for line in "${LISTING[@]:-}"; do
  [[ -n "$line" ]] || continue
  read -r size updated path _ <<< "$line"
  [[ "$size" =~ ^[0-9]+$ ]] || continue
  updated_ts=$(date -d "$updated" +%s 2>/dev/null) || continue
  if (( updated_ts < CUTOFF )); then
    gcloud storage rm "$path" --quiet && DELETED=$((DELETED + 1)) || echo "Échec de suppression : $path" >&2
  fi
done

echo "Purge terminée : ${DELETED} objet(s) supprimé(s)."