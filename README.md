# iac-infra

Infrastructure as Code - Administrateur Syst�me DevOps (RNCP 36061)

## Description
Ce projet automatise le d�ploiement d'une infrastructure web avec :
- **Vagrant** : provisioning de VMs locales (Ubuntu 22.04)
- **Ansible** : configuration automatis�e des serveurs (Nginx)
- **Terraform** : Infrastructure as Code
- **GitHub Actions** : pipeline CI (lint YAML + validation Terraform)

## Architecture
`
[ VM Web - 192.168.56.10 ]
  +-- Nginx (install� par Ansible)
`

## Pr�requis
- VirtualBox 7.x
- Vagrant 2.4.x
- Terraform 1.14.x

## Utilisation

### D�marrer l'infrastructure
`ash
vagrant up
`

### V�rifier que Nginx fonctionne
`ash
vagrant ssh web
curl http://192.168.56.10
`

### D�truire l'infrastructure
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

## Comp�tences RNCP couvertes
- BC01-CP1 : Automatiser la cr�ation de serveurs (script Bash)
- BC01-CP2 : Automatiser le d�ploiement d'une infrastructure (Ansible + Terraform)
- BC02-CP8 : Pipeline CI/CD (GitHub Actions)

## Auteur
Lo�c - Formation ASD RNCP 36061
