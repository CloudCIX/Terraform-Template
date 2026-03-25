locals {
  _rule_parts = { for idx, rule in distinct(var.firewall_rules) : idx =>
    split(" ", replace(replace(rule, " immutable", ""), " mutable", ""))
  }

  firewall_rules = [for idx, parts in local._rule_parts : {
    allow       = true
    description = ""
    destination = strcontains(parts[5], "/") ? parts[5] : "${parts[5]}/32"
    inbound     = parts[0] == "in"
    port        = parts[2] == parts[3] ? parts[2] : "${parts[2]}-${parts[3]}"
    protocol    = parts[1]
    source      = strcontains(parts[4], "/") ? parts[4] : "${parts[4]}/32"
  }]
}

# Routers:
resource "cloudcix_network_router" "example_network_router" {
  project_id = cloudcix_project.example_project.id
  metadata = {
    nat = true
  }
  name = "${var.project_name} Router"
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
  name       = "${var.project_name} Firewall"
  rules      = local.firewall_rules
  type       = "project"
}
