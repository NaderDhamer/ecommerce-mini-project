#!/usr/bin/env bash
# Run Ansible deploy against the EC2 instance from terraform/ (git + docker compose).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TERRAFORM_DIR="$ROOT/terraform"
SSH_KEY="${SSH_KEY:-}"
EC2_USER="${EC2_USER:-ec2-user}"
GITHUB_REPO_URL="${GITHUB_REPO_URL:-}"
DEPLOY_BRANCH="${DEPLOY_BRANCH:-main}"

usage() {
  echo "Usage: $0 -i <path-to.pem> -r <github-repo-url> [-h host] [-b branch]"
  echo "  host defaults to: terraform output -raw public_ip"
  echo "  DB_PASSWORD env var should match terraform db_password"
  exit 1
}

HOST=""
while getopts "i:h:r:b:" opt; do
  case "$opt" in
    i) SSH_KEY="$OPTARG" ;;
    h) HOST="$OPTARG" ;;
    r) GITHUB_REPO_URL="$OPTARG" ;;
    b) DEPLOY_BRANCH="$OPTARG" ;;
    *) usage ;;
  esac
done

[[ -n "$SSH_KEY" && -n "$GITHUB_REPO_URL" ]] || usage
[[ -f "$SSH_KEY" ]] || { echo "Key not found: $SSH_KEY"; exit 1; }

if [[ -z "$HOST" ]]; then
  HOST="$(terraform -chdir="$TERRAFORM_DIR" output -raw public_ip)"
fi

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook not found. Install: pip install ansible"
  exit 1
fi

INVENTORY="$(mktemp)"
trap 'rm -f "$INVENTORY"' EXIT

cat > "$INVENTORY" <<EOF
all:
  hosts:
    ecommerce:
      ansible_host: ${HOST}
      ansible_user: ${EC2_USER}
EOF

export ANSIBLE_HOST_KEY_CHECKING="${ANSIBLE_HOST_KEY_CHECKING:-False}"
export ANSIBLE_CONFIG="${ROOT}/ansible/ansible.cfg"

ansible-playbook "$ROOT/ansible/playbooks/site.yml" \
  -i "$INVENTORY" \
  --private-key "$SSH_KEY" \
  -e "github_repo_url=${GITHUB_REPO_URL}" \
  -e "deploy_branch=${DEPLOY_BRANCH}"

echo "Done. Open: http://${HOST}/"
