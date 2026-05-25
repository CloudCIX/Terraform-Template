variable "cloudcix_api_url" {
  description = "The CloudCIX API base URL."
  default     = "https://api.cloudcix.com/"
}

variable "cloudcix_username" {
  description = "The CloudCIX username (email)."
}

variable "cloudcix_password" {
  description = "The CloudCIX password."
  sensitive   = true
}

variable "cloudcix_api_key" {
  description = "The CloudCIX API key."
  sensitive   = true
}

variable "region_id" {}

variable "project_name" {}

variable "cidr" {
  type    = string
  default = "10.10.10.0/24"
}

variable "nameservers" {
  type        = string
  description = "A comma sepeparated list of nameservers to use"
}

variable "network_name" {}

variable "instance_name" {}

variable "instance_type" {}

variable "hypervisor_type" {}

variable "userdata" {}

variable "instance_specs" {
  type = object({
    cpu = object({
      sku      = string
      quantity = number
    })

    ram = object({
      sku      = string
      quantity = number
    })

    storage = object({
      sku      = string
      quantity = number
    })

    image = object({
      sku      = string
      quantity = number
    })
  })
}


variable "firewall_rules" {
  type        = list(string)
  description = "Rule syntax: {direction} {tcp|udp} {port range start} {port range end} {source IP/CIDR network} {destination IP/CIDR network}"

  validation {
    condition = alltrue([
      for rule in var.firewall_rules :
      contains(["in", "out"], split(" ", rule)[0])
    ])
    error_message = "Direction must be either 'in' or 'out'"
  }

  validation {
    condition = alltrue([
      for rule in var.firewall_rules :
      can(tonumber(split(" ", rule)[2])) &&
      can(tonumber(split(" ", rule)[3])) &&
      tonumber(split(" ", rule)[2]) >= 0 &&
      tonumber(split(" ", rule)[2]) <= 65535 &&
      tonumber(split(" ", rule)[3]) >= 0 &&
      tonumber(split(" ", rule)[3]) <= 65535 &&
      tonumber(split(" ", rule)[2]) <= tonumber(split(" ", rule)[3])
    ])
    error_message = "Port range start and end must be valid numbers between 0-65535, and start must be <= end"
  }
}

variable "storage_volume_name" {
  type        = string
  description = "Name of the storage volume"
}

variable "storage_volume_type" {
  type        = string
  description = "Type of storage volume: 'cephfs' for file system storage or 'cephrbd' for block storage"
  default     = "cephfs"
}

variable "storage_volume_specs" {
  type = object({
    sku      = string
    quantity = number
  })
  description = "Storage volume specifications"
}

variable "storage_volume_mount_path" {
  type        = string
  description = "Mount path for the storage volume"
  default     = null
}

variable "project_note" {
  type        = string
  description = "Optional note to attach to the project"
  default     = ""
}

variable "ssh_key_name" {
  type        = string
  description = "Name for the SSH key record in CloudCIX"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to register with CloudCIX. The API injects it into the instance via ssh_key_names (e.g. contents of ~/.ssh/id_ed25519.pub)"
}