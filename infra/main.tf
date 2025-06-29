provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "example-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}