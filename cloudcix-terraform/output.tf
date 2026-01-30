# ID of project 
output "project_id" {
  value = cloudcix_project.example_project.id
}

# ID of Instance
output "instance_id" {
  value = cloudcix_compute_instance.compute_instance.id
}

# Public IP of Instance
output public_ip {
    value = cloudcix_compute_instance.compute_instance.interfaces[0].ipv4_addresses[0].public_ip
}

output "private_subnet" {
  value = cloudcix_network_router.example_network_router.networks[0].ipv4
}

# Private IP of Instance 
output "private_ip" {
  value = cloudcix_compute_instance.compute_instance.interfaces[0].ipv4_addresses[0].address
}