output "vm1_public_ip" {
  description = "The public IP address of VM1"
  value       = azurerm_public_ip.vm1_ip.ip_address
}

output "vm2_public_ip" {
  description = "The public IP address of VM2"
  value       = azurerm_public_ip.vm2_ip.ip_address
}

output "vm1_private_ip" {
  description = "The private IP address of VM1"
  value       = azurerm_network_interface.vm1_nic.ip_configuration[0].private_ip_address
}

output "vm2_private_ip" {
  description = "The private IP address of VM2"
  value       = azurerm_network_interface.vm2_nic.ip_configuration[0].private_ip_address
}

output "vm1_id" {
  description = "The ID of VM1"
  value       = azurerm_linux_virtual_machine.vm1.id
}

output "vm2_id" {
  description = "The ID of VM2"
  value       = azurerm_linux_virtual_machine.vm2.id
}

output "app_vnet_id" {
  description = "The ID of the app virtual network"
  value       = azurerm_virtual_network.app_vnet.id
}

output "hub_vnet_id" {
  description = "The ID of the hub virtual network"
  value       = azurerm_virtual_network.hub_vnet.id
}

output "app_to_hub_peering_id" {
  description = "The ID of the app-vnet to hub-vnet peering"
  value       = azurerm_virtual_network_peering.app_to_hub.id
}

output "hub_to_app_peering_id" {
  description = "The ID of the hub-vnet to app-vnet peering"
  value       = azurerm_virtual_network_peering.hub_to_app.id
}

# Output to display the Firewall Public IP
output "firewall_public_ip" {
  value = azurerm_public_ip.firewall_pip.ip_address
}

output "firewall_id" {
  value = azurerm_firewall.az_firewall.id
}
