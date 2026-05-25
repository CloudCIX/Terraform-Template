# ID of project 
output "project_id" {
  value = cloudcix_project.example_project.id
}

# ID of Instance
output "instance_id" {
  value = cloudcix_compute_instance.compute_instance.id
}

# Public IP of Instance
# Note: populated after provisioning completes (provider polls until "running" state)
output "public_ip" {
  value = cloudcix_compute_instance.compute_instance.interfaces[0].ipv4_addresses[0].public_ip
}

output "private_subnet" {
  value = cloudcix_network_router.example_network_router.networks[0].ipv4
}

# Private IP of Instance 
output "private_ip" {
  value = cloudcix_compute_instance.compute_instance.interfaces[0].ipv4_addresses[0].address
}

# Storage Volume ID
output "storage_volume_id" {
  value = cloudcix_storage_volume.example_storage_volume.id
}

# SSH Key ID
output "ssh_key_id" {
  value = cloudcix_compute_ssh_key.instance_ssh_key.id
}

# Private key — only populated when ssh_public_key is omitted and the API auto-generates the keypair.
# Retrieve with: terraform output -raw ssh_private_key
output "ssh_private_key" {
  value     = cloudcix_compute_ssh_key.instance_ssh_key.private_key
  sensitive = true
}