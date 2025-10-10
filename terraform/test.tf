# output "droplets" {
#   value = [for d in data.digitalocean_droplets.todos.droplets : {
#     nombre = d.name
#     región = d.region
#     ip     = d.ipv4_address
#   }]
# }