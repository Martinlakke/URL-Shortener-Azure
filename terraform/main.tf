locals {
  name_suffix = "${var.project}-${var.environment}"

  tags = {
    project     = var.project
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "app" {
  name     = "rg-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "./modules/network"

  name_suffix         = local.name_suffix
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name
  tags                = local.tags
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_container_registry" "this" {
  name                = "acrurlshortener${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.app.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = local.tags
}

data "azurerm_client_config" "current" {}

resource "random_password" "db" {
  length  = 24
  special = false
}

resource "azurerm_key_vault" "this" {
  name                       = "kv-urlshortener-${random_string.suffix.result}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.app.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = local.tags
}

resource "azurerm_role_assignment" "kv_secrets_admins" {
  for_each             = var.kv_admin_object_ids
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.value
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = random_password.db.result
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [azurerm_role_assignment.kv_secrets_admins]
  
}

module "database" {
  source = "./modules/database"

  name_suffix         = local.name_suffix
  unique_suffix       = random_string.suffix.result
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name
  vnet_id             = module.network.vnet_id
  subnet_id           = module.network.db_subnet_id
  admin_password      = random_password.db.result
  tags                = local.tags
}
