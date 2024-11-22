# Virtual Network
resource "azurerm_virtual_network" "app_vnet" {
  name                = var.app_vnet_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = var.app_address_space

  # Specify custom DNS servers for the virtual network
  # 1.1.1.1 and 1.0.0.1 are the IP addresses of Cloudflare's public DNS servers
  # Any VM or other resources connected to this virtual network will use these IPs for DNS resolution 
  #  unless they have custom DNS configurations at the NIC or OS level.
  dns_servers = ["1.1.1.1", "1.0.0.1"]

  tags = local.common_tags
}

#  Subnet
resource "azurerm_subnet" "app_subnet" {
  for_each             = var.app_subnet
  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [each.value]
}

# Virtual Network - 2
resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = var.hub_address_space

  tags = local.common_tags
}

# Default Subnet - 2
resource "azurerm_subnet" "hub_vnet_subnet" {
  for_each             = var.hub_subnet
  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [each.value]
}

# Define the peering from app-vnet to hub-vnet
# It enables to seamlessly connect two or more Virtual Networks in Azure.
resource "azurerm_virtual_network_peering" "app_to_hub" {
  name                      = "app-vnet-to-hub"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.app_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = false
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

# Define the peering from hub-vnet to app-vnet
resource "azurerm_virtual_network_peering" "hub_to_app" {
  name                      = "hub-to-app-vnet"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app_vnet.id
  allow_forwarded_traffic   = false
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

# Route Table
# To ensure the firewall policies are enforced, outbound application traffic must be routed through the firewall.

# A route table is required. This route table will be associated with the frontend and backend subnets.
# A route is required to filter all outbound IP traffic from the subnets to the firewall. The firewall’s private IP address will be used.
resource "azurerm_route_table" "app_vnet_route_table" {
  name                = "app-vnet-firewall-rt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # Tags (Optional)
  tags = local.common_tags
}


# Associate the Route Table with the Subnet
resource "azurerm_subnet_route_table_association" "app_vnet_route_table_associate" {
  subnet_id      = azurerm_subnet.app_subnet["frontend"].id
  route_table_id = azurerm_route_table.app_vnet_route_table.id
}

# Route in the Route Table
resource "azurerm_route" "example" {
  name                = "outbound-firewall"
  resource_group_name = data.azurerm_resource_group.rg.name
  route_table_name    = azurerm_route_table.app_vnet_route_table.name

  # Route Settings
  address_prefix = "0.0.0.0/0"
  next_hop_type  = "VirtualAppliance" # Options: Internet, VirtualAppliance, VirtualNetworkGateway, None

  # For Virtual Appliance
  next_hop_in_ip_address = azurerm_firewall.az_firewall.ip_configuration[0].private_ip_address
}
