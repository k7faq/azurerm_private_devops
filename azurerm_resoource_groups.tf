resource "azurerm_resource_group" "vmss_blu" {
  location = local.location
  name     = join("-", [local.blu, "vmss", random_string.str.result])
  tags     = merge(local.combined_tags, { description = "Base Resources - Blue" })
}

