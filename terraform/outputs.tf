output "private_ips" {
  value = [for n in digitalocean_droplet.swarm_nodes : n.ipv4_address_private]
}
output "manager_public_ip" {
  value = digitalocean_droplet.swarm_nodes[0].ipv4_address
}