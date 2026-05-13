provider "cloudcix" {
  base_url  = var.cloudcix_api_url
  username  = var.cloudcix_username
  password  = var.cloudcix_password
  api_key   = var.cloudcix_api_key
  region_id = var.region_id
}