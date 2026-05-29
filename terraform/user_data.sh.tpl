#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y docker git
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

mkdir -p /usr/local/lib/docker/cli-plugins
curl -fsSL "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

mkdir -p /opt/ecommerce
chown ec2-user:ec2-user /opt/ecommerce

cat > /opt/ecommerce/.env <<ENVEOF
DB_PASSWORD=${db_password}
ENVEOF
chown ec2-user:ec2-user /opt/ecommerce/.env

GITHUB_REPO="${github_repo_url}"
if [ -n "$GITHUB_REPO" ]; then
  rm -rf /opt/ecommerce/app
  git clone "$GITHUB_REPO" /opt/ecommerce/app
  chown -R ec2-user:ec2-user /opt/ecommerce/app
  cd /opt/ecommerce/app
  PUBLIC_IP=$(curl -fsS http://169.254.169.254/latest/meta-data/public-ipv4)
  export DB_PASSWORD='${db_password}'
  export CORS_ORIGINS="http://$PUBLIC_IP,http://localhost"
  docker compose -f docker-compose.aws.yml up -d --build
fi
