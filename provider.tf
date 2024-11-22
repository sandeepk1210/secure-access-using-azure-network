# Terraform version
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.9"
    }
  }
}
# provider.tf
provider "azurerm" {

  features {}

  # Added as don't have permission to register Resource Providers.  Remove this block if have permission.
  resource_provider_registrations = "none"
}

# Define your Azure credentials
# To provide your credentials, you can use:

# 1. Environment variables: Define environment variables like 
##    ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET, and ARM_TENANT_ID.

# 2. Azure CLI authentication: If you're already authenticated with the Azure CLI (az login),
##    Terraform will use those credentials by default.

# 3. Define your Azure credentials in following
# provider "azurerm" {
#   subscription_id = "<YOUR_AZURE_SUBSCRIPTION_ID>"
#   client_id       = "<YOUR_AZURE_CLIENT_ID>"
#   client_secret   = "<YOUR_AZURE_CLIENT_SECRET>"
#   tenant_id       = "<YOUR_AZURE_TENANT_ID>"
#   features {}
# }
