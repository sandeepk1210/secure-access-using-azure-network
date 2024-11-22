# Get current client configuration
data "azurerm_client_config" "current" {}

# Data source for existing Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
