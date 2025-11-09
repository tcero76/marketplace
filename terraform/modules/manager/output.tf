output "manager_ip" {
  value = digitalocean_droplet.swarm_manager.ipv4_address
}

output "swarm_manager" {
  value = digitalocean_droplet.swarm_manager
}