# Private DNS Zone
# Azure Private DNS provides a reliable, secure DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution. 
# By using private DNS zones, you can use your own custom domain names rather than the Azure-provided names.
resource "azurerm_private_dns_zone" "app_dns_servers" {
  name                = var.private_dns_name
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}


# Create Virtual Network Link to the Private DNS Zone with Auto Registration
# Once created, notice the A records have automatically been created for each of the virtual machines.
resource "azurerm_private_dns_zone_virtual_network_link" "app_dns_servers_vnet_link" {
  name                  = "app-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.app_dns_servers.name
  resource_group_name   = data.azurerm_resource_group.rg.name
  virtual_network_id    = azurerm_virtual_network.app_vnet.id

  # Enable auto registration of DNS records in the zone
  registration_enabled = true
}
