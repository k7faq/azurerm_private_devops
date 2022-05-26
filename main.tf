data "azurerm_client_config" "current" {}

resource "random_string" "str" {
  length = 4
  special = false
  upper = false
}

/*

 resource "azurerm_network_watcher" "this" {
   name                = "${local.base_name}-networkwatcher" # "${local.resource_common_name}-networkwatcher"
   location            = azurerm_resource_group.base.location
   resource_group_name = azurerm_resource_group.base.name
   tags                = merge(var.common_tags, tomap({ Role = "Network Watcher for Security" }))
 }*/
