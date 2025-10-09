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