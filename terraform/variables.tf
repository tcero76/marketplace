variable "region" {
  default = "nyc3"
}

variable "ssh_key_name" {
  type        = string
  description = "Nombre de tu clave SSH en DigitalOcean"
}

variable "image" {
  default = "ubuntu-22-04-x64"
}

variable "size" {
  default = "s-1vcpu-1gb"
}

variable "worker_count" {
  description = "Número de nodos worker en el clúster Docker Swarm"
  type        = number
  default     = 2
}

variable "overlay_network" {
  description = "Nombre de la red Overlay"
  type = string
  default = "application"
}
