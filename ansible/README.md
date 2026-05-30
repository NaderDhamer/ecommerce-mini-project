# Ansible deployment

Configures the EC2 instance created by `terraform/` and deploys the app with **git** + `docker-compose.aws.yml`.

Variables live in `inventory/group_vars/all.yml` (loaded when using `inventory/ci.yml` or `inventory/hosts.yml`).

## What runs where

| Step | Tool |
|------|------|
| Create EC2 + security group | `terraform apply` |
| Install Docker, clone repo, start stack | Ansible (`playbooks/site.yml`) |
| Automated deploy on push | GitHub Actions (`.github/workflows/deploy-ec2.yml`) |

## GitHub Actions (recommended)

1. Run `terraform apply` once.
2. Add repository secrets (see [.github/DEPLOY.md](../.github/DEPLOY.md)).
3. Push to `main` or `master` — the workflow runs this playbook against EC2.

## Manual run from your machine

```bash
pip install ansible   # or: sudo apt install ansible

cp ansible/inventory/hosts.yml.example ansible/inventory/hosts.yml
# Edit hosts.yml: ansible_host, ansible_ssh_private_key_file

export DB_PASSWORD='same-as-terraform-tfvars'
ansible-playbook ansible/playbooks/site.yml \
  -e "github_repo_url=https://github.com/YOUR_USER/Ecommerce-mini-project.git" \
  -e "deploy_branch=main"
```

Or use the helper script (reads Terraform output for the host):

```bash
export DB_PASSWORD='YourDbPasswordFromTfvars'
./scripts/ansible-deploy.sh -i ~/.ssh/your-key.pem \
  -r "https://github.com/YOUR_USER/Ecommerce-mini-project.git"
```

First deploy can take **10–20 minutes** (Docker image builds + MySQL init).
