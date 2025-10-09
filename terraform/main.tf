terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# -----------------------------
# 1️⃣  Crear VPC privada
# -----------------------------
resource "digitalocean_vpc" "swarm_vpc" {
  name   = "swarm-vpc"
  region = var.region
  ip_range = "10.50.0.0/16"
}

# -----------------------------
# 2️⃣  Crear Droplets SIN IP pública
# -----------------------------
data "digitalocean_ssh_key" "default" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "swarm_nodes" {
  count  = 3
  name   = "swarm-node-${count.index + 1}"
  region = var.region
  size   = var.size
  image  = var.image
  vpc_uuid = digitalocean_vpc.swarm_vpc.id
  ipv6   = false
  monitoring = true
  ssh_keys = [data.digitalocean_ssh_key.default.id]
  private_networking = true
  backups = false
  user_data = templatefile("${path.module}/install_docker.sh.tmpl", {
    manager_ip = count.index == 0 ? "" : digitalocean_droplet.swarm_nodes[0].ipv4_address_private
    is_manager = count.index == 0 ? true : false
  })
}

# -----------------------------
# 3️⃣  Crear Cloud Firewall
# -----------------------------
resource "digitalocean_firewall" "swarm_fw" {
  name = "swarm-private-fw"

  droplet_ids = [for n in digitalocean_droplet.swarm_nodes : n.id]

  # Permitir SSH solo desde tu IP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"] 
  }

  # Permitir comunicación interna Swarm
  inbound_rule {
    protocol         = "tcp"
    port_range       = "2377"
    source_addresses = ["10.50.0.0/16"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "7946"
    source_addresses = ["10.50.0.0/16"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "7946"
    source_addresses = ["10.50.0.0/16"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "4789"
    source_addresses = ["10.50.0.0/16"]
  }

  # Salida solo HTTP y HTTPS
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0"]
  }
}
