provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name = var.secret_var_1
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name = var.secret_var_2
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}