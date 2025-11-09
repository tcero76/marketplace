terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Manager
resource "digitalocean_droplet" "swarm_manager" {
  name      = "swarm-manager"
  vpc_uuid  = var.vpc
  region    = var.region
  size      = var.size
  image     = var.image
  ssh_keys  = var.ssh_keys

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

  user_data = templatefile("${path.module}/scripts/install_docker_manager.sh.tmpl", {
    manager_ip = ""
    is_manager = true
    internal_pubkey = var.internal_pubkey
    internal_privkey = ""
    network = var.overlay_network
  })
}


resource "digitalocean_volume" "postgres_data" {
  name   = "swarm-postgres-data"
  region = var.region
  size   = 10
}

resource "digitalocean_volume_attachment" "postgres_data_attachment" {
  droplet_id = digitalocean_droplet.swarm_manager.id
  volume_id  = digitalocean_volume.postgres_data.id
}