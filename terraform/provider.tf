terraform {
    required_providers {
        proxmox = {
            source  = "bpg/proxmox"
            version = "0.104.0"
        }
        random = {
            source  = "hashicorp/random"
            version = "3.8.1"
        }
        tls = {
            source  = "hashicorp/tls"
            version = "4.3.0" # Актуальная стабильная версия
        }
    }
}

provider "proxmox" {
    endpoint  = var.proxmox_api_url
    api_token = var.proxmox_api_token
    insecure  = true
}

resource "tls_private_key" "ansible_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}