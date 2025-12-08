terraform {
  cloud {
    organization = "Sugarfever"
    workspaces {
      name = "Sugarfever"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_vpc" "default" {
  region = var.region
}

data "digitalocean_ssh_key" "default" {
  name = var.ssh_key_name
}

# Generar un par SSH temporal
resource "tls_private_key" "swarm_internal" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "manager" {
  source = "./modules/manager"
  region          = var.region
  size            = var.size
  image           = var.image
  ssh_private_key = var.ssh_private_key
  overlay_network = var.overlay_network
  internal_pubkey = tls_private_key.swarm_internal.public_key_openssh
  vpc = data.digitalocean_vpc.default.id
  ssh_keys  = [data.digitalocean_ssh_key.default.id]
}

module "worker" {
  source = "./modules/worker"
  region          = var.region
  size            = var.size
  image           = var.image
  worker_count    = var.worker_count
  ssh_private_key = var.ssh_private_key
  manager_ip      = module.manager.manager_ip
  internal_privkey = tls_private_key.swarm_internal.private_key_pem
  ssh_keys  = [data.digitalocean_ssh_key.default.id]
  vpc = data.digitalocean_vpc.default.id
  depends = module.manager.swarm_manager
}

# # -----------------------------
# # 3️⃣  Crear Cloud Firewall
# # -----------------------------
# resource "digitalocean_firewall" "swarm_fw" {
#   name = "swarm-private-fw"

#   droplet_ids = [for n in digitalocean_droplet.swarm_nodes : n.id]

#   # Permitir SSH solo desde tu IP
#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "22"
#     source_addresses = ["0.0.0.0/0"] 
#   }

#   # Permitir comunicación interna Swarm
#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "2377"
#     source_addresses = ["10.50.0.0/16"]
#   }

#   inbound_rule {
#     protocol         = "tcp"
#     port_range       = "7946"
#     source_addresses = ["10.50.0.0/16"]
#   }

#   inbound_rule {
#     protocol         = "udp"
#     port_range       = "7946"
#     source_addresses = ["10.50.0.0/16"]
#   }

#   inbound_rule {
#     protocol         = "udp"
#     port_range       = "4789"
#     source_addresses = ["10.50.0.0/16"]
#   }

#   # Salida solo HTTP y HTTPS
#   outbound_rule {
#     protocol              = "tcp"
#     port_range            = "80"
#     destination_addresses = ["0.0.0.0/0"]
#   }

#   outbound_rule {
#     protocol              = "tcp"
#     port_range            = "443"
#     destination_addresses = ["0.0.0.0/0"]
#   }
# }
