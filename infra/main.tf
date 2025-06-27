provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "jobportal_rg" {
  name     = "jobportal-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "jobportal_vnet" {
  name                = "jobportal-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jobportal_rg.location
  resource_group_name = azurerm_resource_group.jobportal_rg.name
}

resource "azurerm_subnet" "jobportal_subnet" {
  name                 = "jobportal-subnet"
  resource_group_name  = azurerm_resource_group.jobportal_rg.name
  virtual_network_name = azurerm_virtual_network.jobportal_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_app_service_plan" "jobportal_asp" {
  name                = "jobportal-asp"
  location            = azurerm_resource_group.jobportal_rg.location
  resource_group_name = azurerm_resource_group.jobportal_rg.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "jobportal_webapp" {
  name                = "jobportal-webapp"
  location            = azurerm_resource_group.jobportal_rg.location
  resource_group_name = azurerm_resource_group.jobportal_rg.name
  app_service_plan_id = azurerm_app_service_plan.jobportal_asp.id

  site_config {
    always_on = true
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}

resource "azurerm_storage_account" "jobportal_storage" {
  name                     = "jobportalstor${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.jobportal_rg.name
  location                 = azurerm_resource_group.jobportal_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_postgresql_flexible_server" "jobportal_db" {
  name                   = "jobportal-db"
  resource_group_name    = azurerm_resource_group.jobportal_rg.name
  location               = azurerm_resource_group.jobportal_rg.location
  administrator_login    = "jobportaladmin"
  administrator_password = "P@ssw0rd12345!"
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.job