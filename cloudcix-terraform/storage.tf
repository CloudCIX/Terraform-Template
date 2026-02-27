resource "cloudcix_storage_volume" "example_storage_volume" {
  project_id = cloudcix_project.example_project.id
  
  specs = [{
    quantity = var.storage_volume_specs.quantity
    sku_name = var.storage_volume_specs.sku
  }]
  
  name = var.storage_volume_name
  type = var.storage_volume_type
  
  metadata = {
    attach_instance_ids = [cloudcix_compute_instance.compute_instance.id]
    #mount_path          = var.storage_volume_mount_path
  }

  depends_on = [
    cloudcix_compute_instance.compute_instance
  ]
}
