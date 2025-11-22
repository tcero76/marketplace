output "manager_public_ip" {
  value = module.manager.manager_ip
}

output "worker_public_ip" {
  value = module.worker.worker_ip
}