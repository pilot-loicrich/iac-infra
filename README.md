# iac-infra

Infrastructure as Code - Administrateur Système DevOps (RNCP 36061)

## Description
Ce projet automatise le déploiement d'une infrastructure web avec :
- **Vagrant** : provisioning de VMs locales (Ubuntu 22.04)
- **Ansible** : configuration automatisée des serveurs (Nginx)
- **Terraform** : Infrastructure as Code
- **GitHub Actions** : pipeline CI (lint YAML + validation Terraform)

## Architecture
`
[ VM Web - 192.168.56.10 ]
  +-- Nginx (installé par Ansible)
`

## Prérequis
- VirtualBox 7.x
- Vagrant 2.4.x
- Terraform 1.14.x

## Utilisation

### Démarrer l'infrastructure
`ash
vagrant up
`

### Vérifier que Nginx fonctionne
`ash
vagrant ssh web
curl http://192.168.56.10
`

### Détruire l'infrastructure
`ash
vagrant destroy -f
`

### Terraform
`ash
cd terraform
terraform init
terraform plan
terraform apply
`

## Compétences RNCP couvertes
- BC01-CP1 : Automatiser la création de serveurs (script Bash)
- BC01-CP2 : Automatiser le déploiement d'une infrastructure (Ansible + Terraform)
- BC02-CP8 : Pipeline CI/CD (GitHub Actions)

## Auteur
Loïc - Formation ASD RNCP 36061
