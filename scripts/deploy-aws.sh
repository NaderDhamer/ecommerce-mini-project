#!/usr/bin/env bash
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

rsync -avz --delete \
  -e "ssh -i $SSH_KEY" \
  --exclude node_modules \
  --exclude .git \
  --exclude .terraform \
  --exclude '*.tfstate*' \
  --exclude .idea \
  "$ROOT/" "$EC2_USER@$HOST:$REMOTE_DIR/"

ssh -i "$SSH_KEY" "$EC2_USER@$HOST" bash -s <<REMOTE
set -euo pipefail
cd "$REMOTE_DIR"
PUBLIC_IP=\$(curl -fsS http://169.254.169.254/latest/meta-data/public-ipv4)
export CORS_ORIGINS="http://\${PUBLIC_IP},http://localhost"
if [[ -f /opt/ecommerce/.env ]]; then set -a; source /opt/ecommerce/.env; set +a; fi
docker compose -f docker-compose.aws.yml up -d --build
docker compose -f docker-compose.aws.yml ps
REMOTE

echo "Done. Open: http://${HOST}/"
