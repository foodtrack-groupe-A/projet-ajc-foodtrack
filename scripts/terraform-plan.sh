#!/usr/bin/env bash

set -euo pipefail

ENVIRONMENT="${1:-dev}"

case "$ENVIRONMENT" in
  dev|test|prod)
    ;;
  *)
    echo "Environnement invalide : $ENVIRONMENT"
    echo "Utilisation : ./scripts/terraform-plan.sh dev|test|prod"
    exit 1
    ;;
esac

export GODEBUG="netdns=go"

terraform -chdir=terraform init -input=false

terraform -chdir=terraform plan \
  -var-file="${ENVIRONMENT}.tfvars" \
  -input=false \
  -parallelism=1