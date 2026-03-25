resource "cloudcix_project" "example_project" {
  name      = var.project_name
  region_id = var.region_id
  note      = var.project_note
}