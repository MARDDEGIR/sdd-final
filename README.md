# SDD Navigator — Kubernetes Infrastructure

Deploys the SDD Navigator stack (Rust API + PostgreSQL + Next.js frontend) to Kubernetes using Helm charts orchestrated by Ansible, with CI validation.

## Architecture

```
charts/sdd-navigator/        # Umbrella Helm chart
  charts/api/                # Rust API subchart
  charts/frontend/           # nginx + Next.js subchart
  templates/ingress.yaml     # Ingress routing /api/* and /
ansible/                     # Ansible orchestration
scripts/                     # Traceability enforcement
.github/workflows/           # CI pipeline
```

## PostgreSQL: Bitnami subchart

Uses Bitnami PostgreSQL Helm subchart. Credentials stored in Kubernetes Secret, never in plaintext.

## Run locally

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency update charts/sdd-navigator
helm template sdd-navigator charts/sdd-navigator
helm lint charts/sdd-navigator --strict
```

## Deploy with Ansible

```bash
export SDD_DB_PASSWORD=your_secure_password
ansible-playbook -i ansible/inventory/local.yml ansible/playbook.yml
```

## Traceability check

```bash
bash scripts/check-traceability.sh
```

## CI runs

- Passing CI (main): https://github.com/MARDDEGIR/sdd-final/actions/runs/23631881397
- Failing CI (demo/violation): https://github.com/MARDDEGIR/sdd-final/actions/runs/23631962807
