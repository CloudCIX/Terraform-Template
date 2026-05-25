cloudcix_api_url  = "https://api.cloudcix.com/"
cloudcix_username = "example@cix.ie"
cloudcix_password = "My_Secure_Password"
cloudcix_api_key  = "My_API_Key"
region_id         = 1
project_name = "My First Project"
project_note = "Optional description of this project"
cidr          = "10.0.0.0/24"
network_name  = "My First Network"
nameservers   = "9.9.9.9, 91.103.0.1, 8.8.8.8, 1.1.1.1, 2001:4860:4860::8888, 2620:fe::fe, 2606:4700:4700::1111"
instance_name = "My First Instance"

instance_type   = "virtual-machine"
hypervisor_type = "lxd"

# SSH Key — registered with CloudCIX; public key injected into the instance by the API via ssh_key_names
ssh_key_name   = "my-laptop-key"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..."

# passwd/ssh_pwauth are optional when using an SSH key — omit them to disable password auth entirely
userdata = <<-EOF
#cloud-config
users:
  - name: administrator
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: <YOUR_HASHED_PASSWORD>  # optional if using SSH key; generate with: openssl passwd -6 yourpassword
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
    quantity = 16
  }

  image = {
    sku      = "SURF001"
    quantity = 1
  }
}

firewall_rules = [
  # Allow SSH (port 22) from trusted source range
  "in tcp 22 22 91.103.3.36/24 10.0.0.0/24",
  "in tcp 80 80 0.0.0.0/0 10.0.0.0/24",
  "in tcp 443 443 0.0.0.0/0 10.0.0.0/24"
]

storage_volume_name = "ceph"
storage_volume_type = "cephfs"
# options: "cephfs" for filesystem storage or "cephrbd" for block storage
storage_volume_mount_path = "/mnt/ceph"
# storage_volume_mount_path only used if storage_volume_type is cephfs
storage_volume_specs = {
  sku      = "CEPH_001"
  quantity = 5
}
# CEPH_001 for HDD, CEPH_002 for SSD
