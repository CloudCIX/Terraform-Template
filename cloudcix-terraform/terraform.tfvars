cloudcix_api_url  = "https://api.cloudcix.com/"
cloudcix_username = "your-email@example.com"
cloudcix_password = "<YOUR_PASSWORD>"
cloudcix_api_key  = "<YOUR_API_KEY>"
region_id         = 0  # replace with your region ID
project_name      = "My First Project"
project_note      = ""
cidr              = "10.0.0.0/24"
network_name      = "My First Network"
nameservers       = "9.9.9.9, 91.103.0.1, 8.8.8.8, 1.1.1.1, 2001:4860:4860::8888, 2620:fe::fe, 2606:4700:4700::1111"
instance_name     = "My First Instance"

instance_type   = "virtual-machine"
hypervisor_type = "lxd"

# SSH Key
# Option A: provide your own public key (e.g. contents of ~/.ssh/id_ed25519.pub)
# Option B: leave ssh_public_key unset (null) — the API auto-generates an Ed25519 keypair
#           and outputs the private key once via `terraform output -raw ssh_private_key`
# ssh_key_name   = "my-key"
# ssh_public_key = null  # or: "ssh-ed25519 AAAA..."

# Cloud-init — SSH key is injected automatically; password is optional when using a key
# generate with: openssl passwd -6 yourpassword
userdata = <<-EOF
#cloud-config
users:
  - name: administrator
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: <YOUR_HASHED_PASSWORD>
chpasswd:
  expire: false
ssh_pwauth: true
EOF

instance_specs = {
  cpu = {
    sku      = "vCPU_001"
    quantity = 2
  }

  ram = {
    sku      = "RAM_001"
    quantity = 2
  }

  storage = {
    sku      = "SSD_001"
    quantity = 20
  }

  image = {
    sku      = "SURF001"  # check available images with your CloudCIX provider
    quantity = 1
  }
}

firewall_rules = [
  "in tcp 22 22 91.103.3.36/32 10.0.0.0/24",
  "in tcp 80 80 0.0.0.0/0 10.0.0.0/24",
  "in tcp 443 443 0.0.0.0/0 10.0.0.0/24",
]

# Storage volume (optional — uncomment storage.tf variables to use)
storage_volume_name = "my-volume"
storage_volume_type = "cephfs"   # or "cephrbd"
storage_volume_mount_path = "/mnt/data"
storage_volume_specs = {
  sku      = "CEPH_002"  # CEPH_001 HDD, CEPH_002 SSD
  quantity = 20
}
