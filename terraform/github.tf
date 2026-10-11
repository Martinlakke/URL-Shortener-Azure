resource "azurerm_user_assigned_identity" "github" {
  name                = "id-github-${local.name_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name
  tags                = local.tags
}

resource "azurerm_federated_identity_credential" "github_main" {
  name                = "github-main"
  user_assigned_identity_id = azurerm_user_assigned_identity.github.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${var.github_repo}:ref:refs/heads/main"
}

resource "azurerm_role_assignment" "github_rg_contributor" {
  scope                = azurerm_resource_group.app.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github.principal_id
}