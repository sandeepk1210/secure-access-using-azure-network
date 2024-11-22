# Public IP for Firewall
resource "azurerm_public_ip" "firewall_pip" {
  name                = var.firewall_public_ip_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = var.public_ip_sku
  zones               = var.public_ip_zones
  tags                = local.common_tags
}

# Firewall Policy
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "${var.firewall_name}-policy"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku = var.firewall_tier
}

# Application Rule of firewall policy
# Purpose: Manage and control web and application-level traffic.
#
# What it does:
#   Filters traffic based on the application layer (Layer 7 of the OSI model).
#   Allows or blocks traffic to specific Fully Qualified Domain Names (FQDNs) like dev.azure.com or azure.microsoft.com.
#   Useful for controlling access to cloud services, APIs, or specific websites.
#
# Use Case:
#   Allowing access to Azure DevOps services for deployments while blocking non-business-related websites.

# Network Rule of firewall policy
# Purpose: Manage traffic at the network layer.
#
# What it does:
#   Filters traffic based on source and destination IP addresses, ports, and protocols (Layer 4 of the OSI model).
#   Ensures that traffic like DNS (UDP/port 53) or other specific services is either allowed or blocked.
#
# Use Case:
#   Allowing DNS traffic to specific DNS servers (like 1.1.1.1 or 1.0.0.1) to ensure controlled name resolution within an enterprise.
resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_rules" {
  name               = "${var.firewall_name}-fwpolicy-rcg"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 400
  application_rule_collection {
    name     = "${var.firewall_name}-fw-rule-collection"
    priority = 300
    action   = "Allow" # Allow or Deny
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses = [
        "10.1.0.0/23",
      ]
      destination_fqdns = ["dev.azure.com", "azure.microsoft.com"] # Destination FQDNs
    }
  }

  network_rule_collection {
    name     = "${var.firewall_name}-fw-nrc-dns"
    priority = 200
    action   = "Allow" # Allow or Deny
    rule {
      name              = "network_rule_collection1_rule1"
      protocols         = ["UDP"]
      destination_ports = ["53"]
      source_addresses  = ["10.1.0.0/23"]

      destination_addresses = ["1.1.1.1", "1.0.0.1", ]
    }
  }
}

# Azure Firewall
resource "azurerm_firewall" "az_firewall" {
  name                = var.firewall_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  zones               = var.zones
  sku_name            = "AZFW_VNet" #AZFW_VNet - for regular virtual networks OR AZFW_Hub for hub-and-spoke networks
  sku_tier            = var.firewall_tier

  ip_configuration {
    name                 = "${var.firewall_name}-ipconfig"
    subnet_id            = azurerm_subnet.app_subnet["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }

  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  tags               = local.common_tags
}
