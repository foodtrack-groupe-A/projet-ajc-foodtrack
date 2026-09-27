#!/usr/bin/env bash
set -euo pipefail

# Configuration
CLUSTER_NAME="foodtrack-a-cluster"
NODE_POOL="foodtrack-a-pool" # Ajuste selon le nom exact de ton pool
ZONE="europe-west8-b"

ACTION="${1:-}"

if [[ "$ACTION" != "start" && "$ACTION" != "stop" ]]; then
  echo "Usage: $0 {start|stop}"
  exit 1
fi

if [[ "$ACTION" == "stop" ]]; then
  echo "=== Extinction du pool de nœuds (passage à 0 nœud) ==="
  gcloud container clusters resize "$CLUSTER_NAME" \
    --node-pool "$NODE_POOL" \
    --num-nodes 0 \
    --zone "$ZONE" \
    --quiet
  echo "Pool de nœuds éteint avec succès."
elif [[ "$ACTION" == "start" ]]; then
  echo "=== Démarrage du pool de nœuds (passage à 1 nœud par zone) ==="
  gcloud container clusters resize "$CLUSTER_NAME" \
    --node-pool "$NODE_POOL" \
    --num-nodes 1 \
    --zone "$ZONE" \
    --quiet
  echo "Pool de nœuds démarré avec succès."
fi