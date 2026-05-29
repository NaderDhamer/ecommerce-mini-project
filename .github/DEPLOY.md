# GitHub Actions → EC2 deploy

Pushing to `main` or `master` runs:

1. **CI** (`.github/workflows/ci.yml`) — builds `docker-compose.aws.yml` on GitHub runners.
2. **Deploy** (`.github/workflows/deploy-ec2.yml`) — SSH to your EC2 instance, `git pull`, `docker compose up --build`.

Terraform is **not** run from Actions (Learner Lab credentials expire; keep `terraform apply` local).

## One-time setup on EC2

The instance must exist (Terraform) and allow SSH from GitHub Actions (port 22 open — your `ssh_cidr` may need `0.0.0.0/0` or GitHub’s IP ranges; for labs, `0.0.0.0/0` is common).

Either:

- Terraform `github_repo_url` already cloned the app, **or**
- First deploy will clone into `/opt/ecommerce/app` automatically.

## GitHub repository secrets

**Settings → Secrets and variables → Actions → New repository secret**

| Secret | Value |
|--------|--------|
| `EC2_HOST` | Public IP, e.g. `44.223.34.77` |
| `EC2_SSH_PRIVATE_KEY` | Full contents of `learner-lab.pem` (include `BEGIN` / `END` lines) |
| `EC2_USER` | Optional; default `ec2-user` |

Do **not** commit the `.pem` file.

## After EC2 IP changes

Update the `EC2_HOST` secret when `terraform apply` gives a new public IP.

## Manual deploy

**Actions → Deploy to EC2 → Run workflow**

## Troubleshooting

- **Permission denied (publickey)** — wrong or incomplete `EC2_SSH_PRIVATE_KEY`.
- **git pull failed** — repo must be **public**, or add a deploy key on the server.
- **Smoke test failed** — SSH deploy may have succeeded; SSH in and run `docker compose -f docker-compose.aws.yml logs`.
- **DB password** — Terraform user_data writes `/opt/ecommerce/.env`; deploy sources it automatically.
