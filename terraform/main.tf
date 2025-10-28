terraform {
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

resource "digitalocean_volume" "postgres_data" {
  name   = "swarm-postgres-data"
  region = var.region
  size   = 10
}

# Manager
resource "digitalocean_droplet" "swarm_manager" {
  name      = "swarm-manager"
  vpc_uuid  = data.digitalocean_vpc.default.id
  region    = var.region
  size      = var.size
  image     = var.image
  ssh_keys  = [data.digitalocean_ssh_key.default.id]

  provisioner "file" {
    source      = "${path.module}/scripts/deploy_stack.sh"
    destination = "/root/deploy_stack.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/deploy_stack.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.ssh_private_key)
  }

  user_data = templatefile("${path.module}/install_docker.sh.tmpl", {
    manager_ip = ""
    is_manager = true
    internal_pubkey = tls_private_key.swarm_internal.public_key_openssh
    internal_privkey = ""
    network = var.overlay_network
  })
}

resource "digitalocean_volume_attachment" "postgres_data_attachment" {
  droplet_id = digitalocean_droplet.swarm_manager.id
  volume_id  = digitalocean_volume.postgres_data.id
}

# Workers
resource "digitalocean_droplet" "swarm_worker" {
  count     = var.worker_count
  name      = "swarm-worker-${count.index}"
  vpc_uuid  = data.digitalocean_vpc.default.id
  region    = var.region
  size      = var.size
  image     = var.image
  ssh_keys  = [data.digitalocean_ssh_key.default.id]

  depends_on = [digitalocean_droplet.swarm_manager]  # 👈 fuerza el orden
  user_data = templatefile("${path.module}/install_docker.sh.tmpl", {
    manager_ip = digitalocean_droplet.swarm_manager.ipv4_address
    is_manager = false
    internal_privkey = tls_private_key.swarm_internal.private_key_pem
    internal_pubkey = ""
    network = ""
  })
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
