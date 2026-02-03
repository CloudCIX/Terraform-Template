# CloudCIX Terraform Provider - Usage Guide

## Overview

This Terraform configuration allows you to provision and manage CloudCIX infrastructure including projects, compute instances, networks, routers, and firewalls. The provider enables infrastructure-as-code management of CloudCIX resources.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Resources](#resources)
- [Usage Examples](#usage-examples)
- [Variables Reference](#variables-reference)
- [Outputs](#outputs)
- [Firewall Rules](#firewall-rules)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Prerequisites

- Terraform >= 1.0
- CloudCIX account with API access
- CloudCIX API credentials (username, password, API key)
- Access to a CloudCIX region

## Installation

### 1. Clone or Download the Configuration

```bash
git clone https://github.com/CloudCIX/Terraform-Template.git
cd cloudcix-terraform
```

### 2. Set Up API Credentials

Copy the template environment file and configure your CloudCIX API credentials:

```bash
cp cloudcix.env.template cloudcix.env
```

Edit `cloudcix.env` with your CloudCIX credentials:

```bash
CLOUDCIX_API_USERNAME=your_username
CLOUDCIX_API_PASSWORD=your_password
CLOUDCIX_API_KEY=your_api_key
CLOUDCIX_API_V2_URL=https://api.cloudcix.com/api/v2
```

### 3. Initialize Terraform

```bash
terraform init
```

This will download the CloudCIX provider (version ~> 0.10.8) from the Terraform Registry.

## Configuration

### Configure Variables

Edit `terraform.tfvars` to customize your infrastructure:

```hcl
settings_file = "cloudcix.env"
region_id     = <Your_Region_ID>
project_name  = "my-project"

# Network Configuration
cidr          = "10.0.0.0/24"
network_name  = "My Network"
nameservers   = "1.1.1.1,8.8.8.8"

# Instance Configuration
instance_name   = "my-instance"
instance_type   = "virtual-machine"
hypervisor_type = "lxd"

# Cloud-init user data
userdata = "#cloud-config\nusers:\n  - name: administrator\n    groups: sudo\n    shell: /bin/bash\n    lock_passwd: false\n    passwd: $2a$12$...\n"

# Instance Specifications
instance_specs = {
  cpu = {
    sku      = "vCPU_001"
    quantity = 2
  }
  ram = {
    sku      = "RAM_001"
    quantity = 4
  }
  storage = {
    sku      = "SSD_001"
    quantity = 32
  }
  image = {
    sku      = "SURF001"
    quantity = 1
  }
}

# Firewall Rules
firewall_rules = [
  "in tcp 22 22 0.0.0.0/0 10.0.0.0/24",
  "in tcp 80 80 0.0.0.0/0 10.0.0.0/24",
  "in tcp 443 443 0.0.0.0/0 10.0.0.0/24",
]
```

## Resources

This configuration creates the following CloudCIX resources:

### 1. Project (`cloudcix_project`)
Creates a CloudCIX project in the specified region.

### 2. Network Router (`cloudcix_network_router`)
Creates a virtual router with:
- NAT enabled
- Custom IPv4 network (CIDR)
- Network isolation

### 3. Compute Instance (`cloudcix_compute_instance`)
Creates a virtual machine with:
- Custom CPU, RAM, and storage specifications
- Network interface with NAT
- Public and private IP addresses
- Cloud-init userdata support

### 4. Firewall (`cloudcix_network_firewall`)
Creates firewall rules to control inbound/outbound traffic.

## Usage Examples

### Deploy Infrastructure

```bash
# Preview changes
terraform plan

# Apply configuration
terraform apply

# Auto-approve (skip confirmation)
terraform apply -auto-approve
```

### View Outputs

```bash
terraform output
```

Example output:
```
instance_id = "12345"
private_ip = "10.0.0.10"
private_subnet = "10.0.0.0/24"
project_id = "67890"
public_ip = "203.0.113.42"
```

### Modify Infrastructure

Edit `terraform.tfvars` with your changes, then:

```bash
terraform plan
terraform apply
```

### Destroy Infrastructure

```bash
# Preview what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy
```

## Variables Reference

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `settings_file` | string | Path to CloudCIX credentials file |
| `region_id` | number | CloudCIX region ID |
| `project_name` | string | Name for the CloudCIX project |
| `network_name` | string | Name for the virtual network |
| `nameservers` | string | Comma-separated list of DNS servers |
| `instance_name` | string | Name for the compute instance |
| `instance_type` | string | Type of instance (e.g., "virtual-machine") |
| `hypervisor_type` | string | Hypervisor type (e.g., "lxd") |
| `userdata` | string | Cloud-init configuration |
| `instance_specs` | object | Instance specifications (CPU, RAM, storage, image) |
| `firewall_rules` | list(string) | List of firewall rules |

### Optional Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `cidr` | string | "10.10.10.0/24" | IPv4 CIDR for the private network |

### Instance Specifications Object

The `instance_specs` variable expects an object with the following structure:

```hcl
instance_specs = {
  cpu = {
    sku      = "vCPU_001"  # SKU name for CPU
    quantity = 2           # Number of vCPUs
  }
  ram = {
    sku      = "RAM_001"   # SKU name for RAM
    quantity = 4           # GB of RAM
  }
  storage = {
    sku      = "SSD_001"   # SKU name for storage
    quantity = 32          # GB of storage
  }
  image = {
    sku      = "UBUNTU2404"   # SKU name for OS image
    quantity = 1           # Always 1
  }
}
```

**Common SKUs:**
- CPU: `vCPU_001`
- RAM: `RAM_001`
- Storage: `SSD_001`, `HDD_001`
- Images: `UBUNTU2404` (check with your CloudCIX provider for available images)

## Outputs

| Output | Description |
|--------|-------------|
| `project_id` | ID of the created CloudCIX project |
| `instance_id` | ID of the created compute instance |
| `public_ip` | Public IPv4 address of the instance |
| `private_ip` | Private IPv4 address of the instance |
| `private_subnet` | CIDR of the private network |

Access outputs with:
```bash
terraform output public_ip
terraform output -json  # All outputs in JSON format
```

## Firewall Rules

### Rule Syntax

Firewall rules follow this format:
```
{direction} {protocol} {port_start} {port_end} {source} {destination}
```

**Parameters:**
- `direction`: `in` (inbound) or `out` (outbound)
- `protocol`: `tcp` or `udp`
- `port_start`: Starting port number (0-65535)
- `port_end`: Ending port number (0-65535)
- `source`: Source IP address or CIDR (e.g., `0.0.0.0/0`, `192.168.1.100/32`)
- `destination`: Destination IP address or CIDR

### Common Firewall Rules Examples

```hcl
firewall_rules = [
  # Allow SSH from anywhere
  "in tcp 22 22 0.0.0.0/0 10.0.0.0/24",
  
  # Allow HTTP from anywhere
  "in tcp 80 80 0.0.0.0/0 10.0.0.0/24",
  
  # Allow HTTPS from anywhere
  "in tcp 443 443 0.0.0.0/0 10.0.0.0/24",
  
  # Allow SSH from specific IP
  "in tcp 22 22 203.0.113.0/24 10.0.0.0/24",
  
  # Allow port range
  "in tcp 8000 8100 0.0.0.0/0 10.0.0.0/24",
  
  # Outbound rule
  "out tcp 443 443 10.0.0.0/24 0.0.0.0/0",
]
```

**Notes:**
- Single IP addresses are automatically converted to /32 CIDR notation
- Port start must be ≤ port end
- Rules are validated before apply
- Use `0.0.0.0/0` for any IP address

## Best Practices

### Cloud-init / Userdata

Example cloud-config:
```yaml
#cloud-config
users:
  - name: admin
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1...

packages:
  - curl
  - git
  - htop

runcmd:
  - echo "Setup complete"
```

## Troubleshooting

### Common Issues

#### 1. Authentication Errors

```
Error: Failed to authenticate with CloudCIX API
```

**Solution:**
- Verify credentials in `cloudcix.env`
- Check API URL is correct
- Ensure API key is active
- Verify network connectivity to CloudCIX API

#### 2. Region Not Found

```
Error: Invalid region_id
```

**Solution:**
- Verify the region_id is correct for your CloudCIX account
- Contact CloudCIX support for available regions
- Check if you have access to the specified region

#### 3. SKU Not Available

```
Error: SKU not found or not available
```

**Solution:**
- Verify SKU names with your CloudCIX provider
- Check SKU availability in your region
- Review CloudCIX documentation for current SKUs

#### 4. CIDR Conflicts

```
Error: Network CIDR overlaps with existing network
```

**Solution:**
- Choose a different CIDR range
- Review existing networks in the CloudCIX project
- Ensure CIDR doesn't conflict with other infrastructure

#### 5. Firewall Rule Validation Errors

```
Error: Firewall rule validation failed
```

**Solution:**
- Check rule syntax matches the required format
- Verify direction is 'in' or 'out'
- Ensure port numbers are between 0-65535
- Verify port_start ≤ port_end
- Check CIDR notation is valid

#### 6. Provider Version Issues

```
Error: Provider version not compatible
```

**Solution:**
```bash
# Update provider to latest version
terraform init -upgrade

# Or specify exact version in versions.tf
terraform {
  required_providers {
    cloudcix = {
      source  = "CloudCIX/cloudcix"
      version = "0.10.8"
    }
  }
}
```

### Debug Mode

Enable detailed logging:

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform-debug.log
terraform apply
```

### Getting Help

1. **Check CloudCIX Documentation**
   - Provider documentation: https://registry.terraform.io/providers/CloudCIX/cloudcix/latest/docs
   - CloudCIX API documentation https://docs.cloudcix.com/

2. **Terraform Commands**
   ```bash
   terraform validate  # Check configuration syntax
   terraform fmt      # Format configuration files
   terraform show     # Show current state
   terraform state list  # List resources in state
   terraform plan    # Preview changes
   terraform apply # Apply changes
   terraform destroy  # Destroy resources
   ```

---

**Version:** 1.0.0  
**Last Updated:** January 2026  
**Provider Version:** ~> 0.10.8
