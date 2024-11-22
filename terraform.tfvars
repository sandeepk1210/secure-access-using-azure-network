resource_group_name = "RG1-lod45998726"
location            = "eastus"

#Network1 as App
app_vnet_name     = "app-vnet"
app_address_space = ["10.1.0.0/16"]
# Creating a firewall with a subnet named AzureFirewallSubnet is a specific requirement
#  when configuring Azure Firewall within a virtual network.
app_subnet = {
  "frontend"            = "10.1.0.0/24"
  "backend"             = "10.1.1.0/24"
  "AzureFirewallSubnet" = "10.1.63.0/26"
}

#Network2 as Hub
hub_vnet_name     = "hub-vnet"
hub_address_space = ["10.0.0.0/16"]
hub_subnet = {
  "AzureFirewallSubnet" = "10.0.0.0/26"
}

# Network Firewall
firewall_name           = "app-vnet-firewall"
public_ip_sku           = "Standard"
firewall_tier           = "Standard" # Can be Basic, Standard or Premium
firewall_public_ip_name = "fwpip"

# DNS
private_dns_name = "private.contoso.com"
