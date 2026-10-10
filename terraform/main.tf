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