variable "region" {}
variable "size" {}
variable "image" {}
variable "overlay_network" {}
variable "internal_pubkey" {}
variable "vpc" {}
variable "ssh_keys" {}
variable "ssh_private_key" {
  type      = string
  sensitive = true
}