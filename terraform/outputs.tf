output "manager_public_ip" {
  value = digitalocean_droplet.swarm_manager.ipv4_address
}