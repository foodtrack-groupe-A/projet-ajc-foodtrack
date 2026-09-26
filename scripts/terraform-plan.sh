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

if [ ! -x /usr/bin/terraform ]; then
  echo "Terraform absent : installation en cours..."

  wget -qO- https://apt.releases.hashicorp.com/gpg |
    sudo gpg --dearmor --yes \
      -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" |
    sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y terraform

  echo "Terraform installé avec succès."
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TF_DIR="${REPO_ROOT}/terraform"

export GODEBUG="netdns=go"

echo "Version de Terraform :"
terraform version

echo "Environnement sélectionné : ${ENVIRONMENT}"
echo "Fichier utilisé : ${ENVIRONMENT}.tfvars"

terraform -chdir="${TF_DIR}" init \
  -input=false

terraform -chdir="${TF_DIR}" plan \
  -var-file="${ENVIRONMENT}.tfvars" \
  -input=false \
  -parallelism=1