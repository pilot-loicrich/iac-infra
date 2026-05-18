# iac-infra

Infrastructure as Code — Administrateur Système DevOps (RNCP 36061)

## Description

Ce projet automatise le déploiement d'une infrastructure web complète avec :

- **Vagrant** : provisioning de VMs locales (Ubuntu 22.04)
- **Ansible** : configuration automatisée (Nginx, sécurité, monitoring)
- **Terraform** : Infrastructure as Code (génération inventaire + infra-info.txt)
- **Docker / Docker Compose** : environnement de développement et stack monitoring
- **Kubernetes** : orchestration conteneurs (Nginx + PostgreSQL)
- **GitHub Actions** : pipeline CI/CD (lint → build → push → validate)

## Architecture

![Architecture iac-infra](docs/architecture_iac-infra.png)

> Schéma complet : VM Ubuntu (Nginx + Security + Monitoring via Ansible) · Kubernetes (Deployment + PVC + HPA) · CI/CD GitHub Actions · Alertmanager → Discord

<details>
<summary>Vue ASCII (alternative texte)</summary>

```
[ Poste développeur — Windows 11 ]
      |
      | vagrant up / ansible-playbook / terraform apply
      v
[ VM Ubuntu 22.04 — 192.168.56.10 (VirtualBox host-only) ]
  +-- Nginx (port 80)                    ← rôle Ansible : common
  +-- UFW + SSH hardening                ← rôle Ansible : security
  +-- Stack monitoring (Docker)          ← rôle Ansible : monitoring
        +-- Prometheus    (port 9090)
        +-- Grafana       (port 3000)    ← dashboard auto-provisionné
        +-- Alertmanager  (port 9093)    → Discord webhook
        +-- node-exporter (port 9100)

[ Kubernetes — kubectl apply -f k8s/ ]
  +-- Nginx Deployment (2 réplicas) + Service NodePort :30080
  +-- PostgreSQL Deployment + PVC 1Gi + Secret
  +-- HPA : autoscaling 2-10 réplicas (CPU > 50%)

[ CI/CD — GitHub Actions ]
  lint (yamllint) → build+push (Docker Hub) → validate (yamllint k8s)
```

</details>

## Prérequis

- VirtualBox 7.x
- Vagrant 2.4.x
- Terraform 1.14.x
- Docker + Docker Compose v2
- kubectl (pour Kubernetes)

## Démarrage rapide

### 1. Infrastructure VM (Vagrant + Ansible)

```bash
vagrant up
```

Cela provisionne la VM et exécute le playbook Ansible qui installe :
- Nginx
- UFW (pare-feu) + SSH hardening
- Stack monitoring complète (Prometheus, Grafana, Alertmanager, node-exporter)

```bash
# Vérifier Nginx
curl http://192.168.56.10

# Détruire la VM
vagrant destroy -f
```

### 2. Environnement de développement (Docker Compose)

Créer un fichier `.env` à la racine :

```env
POSTGRES_USER=admin
POSTGRES_PASSWORD=motdepasse_secret
POSTGRES_DB=testdb
```

```bash
# Démarrer tous les services (web + db + monitoring)
docker compose up -d

# Vérifier les services
docker compose ps
```

Services disponibles :

| Service       | URL                          |
|---------------|------------------------------|
| Nginx         | http://localhost:8080        |
| PostgreSQL    | localhost:5433               |
| Prometheus    | http://localhost:9090        |
| Grafana       | http://localhost:3000        |
| Alertmanager  | http://localhost:9093        |
| node-exporter | http://localhost:9100/metrics|

### 3. Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Génère `ansible/inventory/hosts.ini` et `infra-info.txt`.

## Supervision & Alertes

### Accès Grafana

```
URL      : http://192.168.56.10:3000  (VM)  ou  http://localhost:3000  (dev)
Login    : admin
Mot de passe : admin
```

Le dashboard **Infrastructure** est provisionné automatiquement au démarrage avec 3 panels :
- CPU Usage (%)
- RAM Usage (%)
- Uptime (secondes)

### Alertes Prometheus

Trois alertes sont configurées dans [monitoring/alerts.yml](monitoring/alerts.yml) :

| Alerte          | Seuil              | Sévérité |
|-----------------|--------------------|----------|
| HighCPUUsage    | CPU > 80% / 2 min  | warning  |
| HighMemoryUsage | RAM > 85% / 2 min  | critical |
| NginxDown       | node_exporter down | critical |

### Configurer les notifications (Alertmanager)

Les alertes sont envoyées via Discord webhook. Pour l'activer :

1. Créer un webhook Discord :
   - Paramètres du serveur → Intégrations → Webhooks → Nouveau webhook
   - Copier l'URL du webhook

2. Mettre à jour [monitoring/alertmanager.yml](monitoring/alertmanager.yml) :

```yaml
receivers:
  - name: 'discord-webhook'
    webhook_configs:
      - url: 'https://discord.com/api/webhooks/VOTRE_ID/VOTRE_TOKEN'
```

3. Tester une alerte de bout en bout :

```bash
# Arrêter node-exporter pour déclencher NginxDown
docker compose stop node-exporter

# Vérifier dans Prometheus : http://localhost:9090/alerts
# Attendre 1 minute → l'alerte arrive sur Discord
docker compose start node-exporter
```

## Base de données PostgreSQL

### Premier démarrage

Au premier `docker compose up`, PostgreSQL exécute automatiquement [init_db/schema.sql](init_db/schema.sql) qui crée la table `utilisateurs` et insère des données de test.

### Vérification

```bash
docker compose exec db psql -U admin -d testdb -c "SELECT * FROM utilisateurs;"
```

### Réinitialiser la base

```bash
docker compose down -v          # supprime le volume pgdata
docker compose up -d db         # recrée la base depuis init_db/schema.sql
```

### Sauvegarde / Restauration

```bash
# Sauvegarder
./scripts/backup-postgres.sh

# Restaurer depuis un backup
docker compose exec -T db psql -U admin -d testdb < docker/backups/backup.sql
```

### Kubernetes (PostgreSQL)

```bash
kubectl apply -f kubernetes/postgres-secret.yml
kubectl apply -f kubernetes/postgres.yml

# Initialiser le schéma sur K8s
kubectl exec -it deployment/postgres -- psql -U admin -d testdb < init_db/schema.sql
```

## Pipeline CI/CD

Le pipeline [.github/workflows/ci.yml](.github/workflows/ci.yml) exécute automatiquement à chaque push :

1. **Lint YAML** — validation de tous les fichiers YAML
2. **Lint Terraform** — `terraform fmt` + `terraform validate`
3. **Build Docker** — build de l'image Nginx custom
4. **Push Docker Hub** — push de l'image (sur `main` uniquement)
5. **Validate Kubernetes** — validation des manifests K8s

## Compétences RNCP couvertes

| Bloc | Compétence | Couvert par |
|------|-----------|------------|
| BC01-CP1 | Scripts Bash | `scripts/setup.sh`, `scripts/backup-postgres.sh` |
| BC01-CP2 | IaC | Terraform + Ansible (3 rôles) |
| BC01-CP3 | Sécurité | UFW, SSH hardening, secrets K8s, `.env` non commité |
| BC01-CP4 | Mise en prod | Vagrant + Kubernetes manifests |
| BC02-CP1 | Env de test | Docker Compose dev |
| BC02-CP2 | Stockage | PVC PostgreSQL |
| BC02-CP3 | Conteneurs | Dockerfile + image custom |
| BC02-CP4 | CI/CD | GitHub Actions : lint → build → push → validate |
| BC03-CP1 | KPI | Alertes Prometheus (CPU, mémoire, nginx down) |
| BC03-CP2 | Supervision | Prometheus + Grafana + Alertmanager + dashboard |
| BC03-CP3 | Anglais | Documentation technique (commits, CI, code) |

## Auteur

Loïc NANZO TONLIEU — Formation ASD RNCP 36061
