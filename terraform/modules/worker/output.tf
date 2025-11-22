output "worker_ip" {
  value = digitalocean_droplet.swarm_worker[0].ipv4_address
}