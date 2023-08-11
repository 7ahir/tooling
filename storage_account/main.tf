provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  default     = "tooling_storage_account"
}

variable "location" {
  description = "Azure region for the resources"
  default     = "francecentral"
}

variable "container_name" {
  description = "Name of the Blob container"
  default     = "tfstate-container"
}

resource "azurerm_resource_group" "tooling" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_id" "storage_account_suffix" {
  byte_length = 2
}

resource "azurerm_storage_account" "tooling" {
  name                     = "tfstate-${random_id.storage_account_suffix.hex}"
  resource_group_name      = azurerm_resource_group.tooling.name
  location                 = azurerm_resource_group.tooling.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "tooling"
  }
}

resource "azurerm_storage_container" "tooling" {
  name                  = var.container_name
  storage_account_name = azurerm_storage_account.tooling.name
  container_access_type = "private"
}

output "storage_account_access_key" {
  value = azurerm_storage_account.tooling.primary_access_key
}
