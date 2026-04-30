# Sch�ma d'Architecture - Infrastructure IaC

## Vue globale
`
+---------------------------+
|     Machine H�te          |
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

## Outils utilis�s

| Outil | R�le |
|---|---|
| Vagrant 2.4.9 | Cr�ation et gestion des VMs |
| VirtualBox 7.2 | Hyperviseur |
| Ansible | Configuration automatis�e (Nginx) |
| Terraform 1.14 | Infrastructure as Code |
| GitHub Actions | Pipeline CI (lint YAML + validate) |

## R�seau

| Composant | IP | Port |
|---|---|---|
| Machine h�te | 192.168.56.1 | - |
| VM web | 192.168.56.10 | 80 (HTTP) |

## Flux de d�ploiement
`
1. terraform init/apply  ?  Initialise l'IaC
2. vagrant up            ?  Cr�e la VM Ubuntu
3. ansible playbook      ?  Installe et d�marre Nginx
4. GitHub Actions CI     ?  Lint YAML + Terraform validate
`

## Comp�tences RNCP couvertes (BC01)

- CP1 : Script Bash d'automatisation (scripts/setup.sh)
- CP2 : D�ploiement infra avec Ansible + Terraform
- CP3 : S�curisation (pare-feu UFW, SSH)
- CP4 : Mise en production (vagrant up fonctionnel)
