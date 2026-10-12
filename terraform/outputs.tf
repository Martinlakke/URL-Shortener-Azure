output "resource_group_name" {
  value = azurerm_resource_group.app.name
}

output "acr_name" {
  value = azurerm_container_registry.this.name
}

output "acr_login_server" {
  value = azurerm_container_registry.this.login_server
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "db_fqdn" {
  value = module.database.fqdn
}

output "app_url" {
  value = "https://${azurerm_container_app.api.ingress[0].fqdn}"
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}