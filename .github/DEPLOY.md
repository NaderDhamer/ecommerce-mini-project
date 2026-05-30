# GitHub Actions → EC2 deploy (Ansible)

Pushing to `main` or `master` runs:

1. **CI** (`.github/workflows/ci.yml`) — builds `docker-compose.aws.yml` on GitHub runners.
2. **Deploy** (`.github/workflows/deploy-ec2.yml`) — runs **Ansible** over SSH: install Docker, `git pull` the repo on EC2, `docker compose -f docker-compose.aws.yml up -d --build`.

Terraform is **not** run from Actions (Learner Lab credentials expire; keep `terraform apply` local).

## One-time setup on EC2

1. Run `terraform apply` (creates EC2; minimal user-data only creates `/opt/ecommerce`).
2. Ensure port **22** is reachable from GitHub Actions (`ssh_cidr` — for labs, `0.0.0.0/0` is common).
3. Repository must be **public** for `git clone` on the instance (or add a deploy key manually).

## GitHub repository secrets

**Settings → Secrets and variables → Actions → New repository secret**

| Secret | Value |
|--------|--------|
| `EC2_HOST` | Public IP from `terraform output -raw public_ip` |
| `EC2_SSH_PRIVATE_KEY` | Full contents of your `.pem` (include `BEGIN` / `END` lines) |
| `DB_PASSWORD` | Same value as `db_password` in `terraform/terraform.tfvars` |
| `EC2_USER` | Optional; default `ec2-user` |

Do **not** commit the `.pem` file.

## After EC2 IP changes

Update the `EC2_HOST` secret when `terraform apply` gives a new public IP.

## Manual deploy

- **Actions → Deploy to EC2 → Run workflow**
- Or from your machine: see [ansible/README.md](../ansible/README.md) and `./scripts/ansible-deploy.sh`

## Troubleshooting

- **Permission denied (publickey)** — wrong or incomplete `EC2_SSH_PRIVATE_KEY`.
- **git clone failed** — repo must be **public**, or configure a deploy key on EC2.
- **Smoke test failed** — SSH/Ansible may have succeeded; SSH in and run `docker compose -f docker-compose.aws.yml logs` under `/opt/ecommerce/app`.
- **DB login issues** — ensure `DB_PASSWORD` secret matches Terraform `db_password`; Ansible writes `/opt/ecommerce/.env`.
