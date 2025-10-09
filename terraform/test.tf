terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Solo droplets
data "digitalocean_droplets" "todos" {}

output "droplets" {
  value = [for d in data.digitalocean_droplets.todos.droplets : {
    nombre = d.name
    región = d.region
    ip     = d.ipv4_address
  }]
}