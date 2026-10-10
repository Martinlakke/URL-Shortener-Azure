output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "apps_subnet_id" {
  value = azurerm_subnet.apps.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}