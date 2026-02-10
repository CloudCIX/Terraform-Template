settings_file = "cloudcix.env"

region_id = <YOUR_REGION_ID>

project_name = "My First Project"
cidr          = "10.0.0.0/24"
network_name  = "My First Network"
nameservers   = "9.9.9.9, 91.103.0.1, 8.8.8.8, 1.1.1.1, 2001:4860:4860::8888, 2620:fe::fe, 2606:4700:4700::1111"
instance_name = "My First Instance"

instance_type   = "virtual-machine"
hypervisor_type = "lxd"

userdata = "#cloud-config\nusers:\n  - name: administrator\n    groups: sudo\n    shell: /bin/bash\n    lock_passwd: false\n    passwd: <YOUR_HASHED_PASSWORD>\n    ssh_authorized_keys:\n      - ssh-ed25519 <YOUR_SSH_KEY>\nchpasswd:\n  expire: false\nssh_pwauth: true\n"

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
    sku      = "SURF001"
    quantity = 1
  }
}

firewall_rules = [
  # Allow SSH (port 22) from anywhere
  "in tcp 22 22 91.103.3.36/24 10.0.0.0/24",
]

storage_volume_name = "surf"
storage_volume_type = "cephfs"

storage_volume_specs = {
  sku      = "CEPH_001"
  #use "CEPH_001" for HDD or "CEPH_002" for SSD
  quantity = 10
}

storage_volume_mount_path = "/mnt/surf"