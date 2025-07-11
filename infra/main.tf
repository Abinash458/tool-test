provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "devops_rg" {
  name = var.secret_var_1
  location = "East US"
}
