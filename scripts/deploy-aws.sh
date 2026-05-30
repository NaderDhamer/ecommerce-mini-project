#!/usr/bin/env bash
# Legacy tar-over-SSH deploy. Prefer: ./scripts/ansible-deploy.sh (git + Ansible).
# Deploy application code to the EC2 instance created by terraform/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TERRAFORM_DIR="$ROOT/terraform"
SSH_KEY="${SSH_KEY:-}"
EC2_USER="${EC2_USER:-ec2-user}"
REMOTE_DIR="/opt/ecommerce/app"

usage() {
  echo "Usage: $0 -i <path-to.pem> [-h host]"
  echo "  host defaults to: terraform output -raw public_ip"
  exit 1
}

HOST=""
while getopts "i:h:" opt; do
  case "$opt" in
    i) SSH_KEY="$OPTARG" ;;
    h) HOST="$OPTARG" ;;
    *) usage ;;
  esac
done

[[ -n "$SSH_KEY" ]] || usage
[[ -f "$SSH_KEY" ]] || { echo "Key not found: $SSH_KEY"; exit 1; }

if [[ -z "$HOST" ]]; then
  HOST="$(terraform -chdir="$TERRAFORM_DIR" output -raw public_ip)"
fi

echo "Deploying to $EC2_USER@$HOST:$REMOTE_DIR"

ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new "$EC2_USER@$HOST" "sudo mkdir -p $REMOTE_DIR && sudo chown -R $EC2_USER:$EC2_USER /opt/ecommerce"

echo "Uploading project files (tar over SSH; no rsync required on EC2)..."
tar czf - \
  --exclude=node_modules \
  --exclude=.git \
  --exclude=.terraform \
  --exclude='*.tfstate' \
  --exclude='*.tfstate.*' \
  --exclude=.idea \
  -C "$ROOT" . \
| ssh -i "$SSH_KEY" "$EC2_USER@$HOST" \
  "rm -rf '$REMOTE_DIR'/* && mkdir -p '$REMOTE_DIR' && tar xzf - -C '$REMOTE_DIR'"

ssh -i "$SSH_KEY" "$EC2_USER@$HOST" bash -s "$HOST" <<'REMOTE'
set -euo pipefail
DEPLOY_HOST="$1"
cd /opt/ecommerce/app
export CORS_ORIGINS="http://${DEPLOY_HOST},http://localhost"
if [[ -f /opt/ecommerce/.env ]]; then set -a; source /opt/ecommerce/.env; set +a; fi
docker compose -f docker-compose.aws.yml up -d --build
docker compose -f docker-compose.aws.yml ps
REMOTE

echo "Done. Open: http://${HOST}/"
