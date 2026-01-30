
resource "cloudcix_compute_instance" "compute_instance" {
  depends_on = [
    cloudcix_network_router.example_network_router
  ]
  metadata = {
    dns           = var.nameservers
    instance_type = var.instance_type
    userdata      = var.userdata
  }
  project_id = cloudcix_project.example_project.id
  specs = [{
    quantity = var.instance_specs.cpu.quantity
    sku_name = var.instance_specs.cpu.sku
    }, {
    quantity = var.instance_specs.ram.quantity
    sku_name = var.instance_specs.ram.sku
    }, {
    quantity = var.instance_specs.storage.quantity
    sku_name = var.instance_specs.storage.sku
    }, {
    quantity = var.instance_specs.image.quantity
    sku_name = var.instance_specs.image.sku
  }]
  grace_period = 0
  interfaces = [{
    gateway = true
    ipv4_addresses = [{
      nat = true
    }]
  }]
  name = var.instance_name
  type = var.hypervisor_type
}
