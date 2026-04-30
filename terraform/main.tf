terraform {
  required_version = ">= 1.0"
}

variable "server_name" {
  description = "Nom du serveur web"
  type        = string
  default     = "web-server"
}

variable "environment" {
  description = "Environnement cible (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "server_ip" {
  description = "Adresse IP du serveur"
  type        = string
  default     = "192.168.56.10"
}

resource "local_file" "ansible_inventory" {
  content  = <<-EOT
    [web]
    ${var.server_ip} ansible_connection=local

    [web:vars]
    env=${var.environment}
    server_name=${var.server_name}
  EOT
  filename = "${path.module}/../ansible/inventory/hosts.ini"
}

resource "local_file" "infrastructure_doc" {
  content  = <<-EOT
    # Infrastructure - ${var.environment}
    Serveur : ${var.server_name}
    IP      : ${var.server_ip}
    Env     : ${var.environment}
    Genere  : ${timestamp()}
  EOT
  filename = "${path.module}/../infra-info.txt"
}

output "server_info" {
  value = "Serveur: ${var.server_name} | IP: ${var.server_ip} | Env: ${var.environment}"
}

output "inventory_path" {
  value = "Inventaire Ansible genere : ansible/inventory/hosts.ini"
}
