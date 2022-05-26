# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "base" {
  location = local.location
  name     = join("-", [local.base_name, random_string.str.result])
  tags     = merge(local.combined_tags, { description = "Base Resources - Blue" })
}

resource "azurerm_resource_group" "blu" {
  location = local.location
  name     = join("-", [local.blu, random_string.str.result])
  tags     = merge(local.combined_tags, { description = "Base Resources - Blue" })
}