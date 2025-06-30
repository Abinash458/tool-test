terraform {
  required_providers {
    azurerm = {
      source = var.secret_var_1
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

variable "client_id" {
  description = var.secret_var_2
  type        = string
}

variable "client_secret" {
  description = var.secret_var_3
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = var.secret_var_4
  type        = string
}

variable "subscription_id" {
  description = var.secret_var_5
  type        = string
}

variable "resource_group_name" {
  description = var.secret_var_6
  type        = string
  default = var.secret_var_7
}

variable "location" {
  description = var.secret_var_8
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = var.secret_var_9
  type        = string
  default = var.secret_var_10
}

variable "address_space" {
  description = var.secret_var_11
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
