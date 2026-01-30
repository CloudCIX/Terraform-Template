locals {
  _rule_parts = { for idx, rule in distinct(concat(var.firewall_rules)) : idx =>
    split(" ", replace(replace(rule, " immutable", ""), " mutable", ""))
  }

  _process_rule = { for idx, parts in local._rule_parts : idx =>
    format("%s %s %s %s %s",
      parts[0],                                                # direction
      parts[1],                                                # protocol
      parts[2],                                                # port_start
      parts[3],                                                # port_end
      strcontains(parts[4], "/") ? parts[4] : "${parts[4]}/32" # add /32 if not in CIDR notation
    )
  }

  security_group_rules = distinct(values(local._process_rule))
}

# Routers:
resource "cloudcix_network_router" "example_network_router" {
  project_id = cloudcix_project.example_project.id
  metadata = {
    nat = true
  }
  name = "My First Network Router"
  networks = [
    {
      ipv4 = var.cidr
      name = var.network_name
    }
  ]
  type = "router"
}

# Firewall:
resource "cloudcix_network_firewall" "example_network_firewall" {
  depends_on = [
    cloudcix_network_router.example_network_router
  ]
  project_id = cloudcix_project.example_project.id
  name       = "My First Network Firewall"
  rules = [{
    allow       = true
    description = "description"
    destination = "10.0.0.0/24"
    inbound     = true
    port        = "22"
    protocol    = "tcp"
    source      = "91.103.3.36/32"
  }]
  type = "project"
}
