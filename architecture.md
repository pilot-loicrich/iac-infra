# Schéma d'Architecture - Infrastructure IaC

## Vue globale
`
+---------------------------+
|     Machine Hôte          |
|     Windows 11            |
|                           |
|  +---------------------+  |
|  |  Vagrant + VirtualBox|  |
|  |                     |  |
|  |  +---------------+  |  |
|  |  |  VM : web     |  |  |
|  |  |  Ubuntu 22.04 |  |  |
|  |  |  IP: 192.168  |  |  |
|  |  |  .56.10       |  |  |
|  |  |               |  |  |
|  |  |  [Nginx]      |  |  |
|  |  |  Port 80      |  |  |
|  |  +---------------+  |  |
|  +---------------------+  |
+---------------------------+
`

## Outils utilisés

| Outil | Rôle |
|---|---|
| Vagrant 2.4.9 | Création et gestion des VMs |
| VirtualBox 7.2 | Hyperviseur |
| Ansible | Configuration automatisée (Nginx) |
| Terraform 1.14 | Infrastructure as Code |
| GitHub Actions | Pipeline CI (lint YAML + validate) |

## Réseau

| Composant | IP | Port |
|---|---|---|
| Machine hôte | 192.168.56.1 | - |
| VM web | 192.168.56.10 | 80 (HTTP) |

## Flux de déploiement
`
1. terraform init/apply  ?  Initialise l'IaC
2. vagrant up            ?  Crée la VM Ubuntu
3. ansible playbook      ?  Installe et démarre Nginx
4. GitHub Actions CI     ?  Lint YAML + Terraform validate
`

## Compétences RNCP couvertes (BC01)

- CP1 : Script Bash d'automatisation (scripts/setup.sh)
- CP2 : Déploiement infra avec Ansible + Terraform
- CP3 : Sécurisation (pare-feu UFW, SSH)
- CP4 : Mise en production (vagrant up fonctionnel)
