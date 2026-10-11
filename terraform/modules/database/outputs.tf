output "fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.app.name
}

output "admin_login" {
  value = azurerm_postgresql_flexible_server.this.administrator_login
}
