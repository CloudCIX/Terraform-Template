resource "cloudcix_compute_ssh_key" "instance_ssh_key" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key # optional — omit or null to have the API auto-generate an Ed25519 keypair
}
