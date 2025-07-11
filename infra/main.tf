resource "azurerm_resource_group" "jobportal_rg" {
  name = var.secret_var_1
  location = var.secret_var_2
}

resource "azurerm_virtual_network" "jobportal_vnet" {
  name = var.secret_var_3
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.jobportal_rg.location
  resource_group_name = azurerm_resource_group.jobportal_rg.name
}

resource "azurerm_network_interface" "jobportal_nic" {
  name = var.secret_var_4
  location            = azurerm_resource_group.jobportal_rg.location
  resource_group_name = azurerm_resource_group.jobportal_rg.name

  ip_configuration {
    name = var.secret_var_5
    subnet_id                     = azurerm_subnet.jobportal_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jobportal_vm" {
  name = var.secret_var_6
  resource_group_name = azurerm_resource_group.jobportal_rg.name
  location            = azurerm_resource_group.jobportal_rg.location
  size = var.secret_var_7
  admin_username = var.secret_var_8
  network_interface_ids = [
    azurerm_network_interface.jobportal_nic.id,
  ]
  admin_password = var.secret_var_9
  disable_password_authentication = false

  os_disk {
    caching = var.secret_var_10
    storage_account_type = var.secret_var_11
    name = var.secret_var_12
  }

  source_image_reference {
    publisher = var.secret_var_13
    offer = var.secret_var_14
    sku = var.secret_var_15
    version   = "latest"
  }
}

resource "azurerm_storage_account" "jobportal_sa" {
  name = var.secret_var_16
  resource_group_name      = azurerm_resource_group.jobportal_rg.name
  location                 = azurerm_resource_group.jobportal_rg.location
  account_tier = var.secret_var_17
  account_replication_type = "LRS"
}

resource "azurerm_postgresql_server" "jobportal_postgres" {
  name = var.secret_var_18
  location            = azurerm_resource_group.jobportal_rg.location
  resource_group_name = azurerm_resource_group.jobportal_rg.name

  sku_name = var.secret_var_19
  storage_mb          = 5120
  backup_retention_days = 7
  geo_redundant_backup_enabled = false
  administrator_login = var.secret_var_20
  administrator_login_password = var.secret_var_21
  version                     = "11"
  ssl_enforcement_enabled     = true
  auto_grow_enabled           = true

  public_network_access_enabled = true
}

resource "azurerm_postgresql_database" "jobportal_db" {
  name = var.secret_var_22
  resource_group_name = azurerm_resource_group.jobportal_rg.name
  server_name         = azurerm_postgresql_server.jobportal_postgres.name
  charset             = "UTF8"
  collation = var.secret_var_23
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "jobportal_kv" {
  name = var.secret_var_24
  location                    = azurerm_resource_group.jobportal_rg.location
  resource_group_name         = azurerm_resource_group.jobportal_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name = var.secret_var_25
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get",
      "set",
      "list",
      "delete",
      "recover",
      "backup",
      "restore"
    ]
  }
}
