#!/bin/bash
# Minimal bootstrap — Docker, git clone, and compose are handled by Ansible (GitHub Actions or manual playbook).
set -euxo pipefail

mkdir -p /opt/ecommerce
chown ec2-user:ec2-user /opt/ecommerce
