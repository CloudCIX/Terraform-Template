variable "settings_file" {}

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