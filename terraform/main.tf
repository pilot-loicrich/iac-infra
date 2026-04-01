terraform {
  required_version = ">= 1.0"
}

variable "server_name" {
  description = "Nom du serveur"
  type        = string
  default     = "web-server"
}

variable "environment" {
  description = "Environnement (dev, staging, prod)"
  type        = string
  default     = "dev"
}

resource "null_resource" "server_config" {
  triggers = {
    server_name = var.server_name
    environment = var.environment
  }

  provisioner "local-exec" {
    command = "echo 'Deploiement de  en '"
  }
}

output "server_info" {
  value = "Serveur:  | Env: "
}
