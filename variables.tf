variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

# Network
variable "app_vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "app_address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

variable "app_subnet" {
  type        = map(string)
  description = "App subnets consists of subnet name and subnet range"
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "hub_address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

variable "hub_subnet" {
  type        = map(string)
  description = "Hub subnets consists of subnet name and subnet range"
}

variable "virtualMachines_VM1_name" {
  description = "Name of the first virtual machine"
  type        = string
  default     = "VM1"
}

variable "virtualMachines_VM2_name" {
  description = "Name of the second virtual machine"
  type        = string
  default     = "VM2"
}

variable "publicIPAddresses_VM1_ip_name" {
  description = "Name of the public IP for VM1"
  type        = string
  default     = "VM1-ip"
}

variable "publicIPAddresses_VM2_ip_name" {
  description = "Name of the public IP for VM2"
  type        = string
  default     = "VM2-ip"
}

variable "virtualNetworks_app_vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "app-vnet"
}

variable "networkInterfaces_VM1_nic_name" {
  description = "Name of the network interface for VM1"
  type        = string
  default     = "VM1-nic"
}

variable "networkInterfaces_VM2_nic_name" {
  description = "Name of the network interface for VM2"
  type        = string
  default     = "VM2-nic"
}

variable "public_ip_VM1" {
  description = "Public IP address for VM1"
  type        = string
  default     = "40.87.123.79"
}

variable "public_ip_VM2" {
  description = "Public IP address for VM2"
  type        = string
  default     = "40.87.123.72"
}

variable "dns_servers" {
  description = "DNS servers for the virtual network"
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}

# Firewall variables
variable "firewall_name" {
  type = string
}

variable "firewall_tier" {
  type = string
}

variable "zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "firewall_public_ip_name" {
  type = string
}

variable "public_ip_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "public_ip_sku" {
  type        = string
  description = "The SKU of the firewall"
}

variable "private_dns_name" {
  type        = string
  description = "Private DNS name"
}
