#resource "azurerm_dns_zone" "this" {
# name                   = local.base_name
#  resource_group_name    = azurerm_resource_group.base.name
#}
#resource "azurerm_dns_a_record" "bastion" {
# name                   = bastion
#  resource_group_name    = azurerm_resource_group.base.name
#  ttl                 = 600
#  zone_name           = local.base_name
#}
/*
resource "azurerm_traffic_manager_profile" "bastion" {
  name                   = local.base_name
  resource_group_name    = azurerm_resource_group.base.name
  profile_status         = "Enabled"
  traffic_routing_method = "Priority"
  traffic_view_enabled   = true
  tags                   = merge(local.combined_tags, { Role = "Bastion Traffic Manager" })

  dns_config {
    relative_name = local.base_name
    ttl           = 300
  }

  monitor_config {
    path                         = null
    protocol                     = "TCP"
    port                         = 22
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_endpoint" "bastion_blu" {
  //resource "azurerm_traffic_manager_azure_endpoint" "eastus-endpoint-api" {
#  count               = contains(["eastus"], azurerm_resource_group.core.location) ? 1 : 0
  name                = "${local.blu}-bastion"
  resource_group_name = azurerm_traffic_manager_profile.bastion.resource_group_name
  profile_name        = azurerm_traffic_manager_profile.bastion.name
  type                = "AzureEndpoints"
  //  profile_id         = azurerm_traffic_manager_profile.bastion.id
  target_resource_id = module.vmss_edge.lb_id
  priority           = "1"
  //  weight             = 1
  endpoint_status = "Enabled"
}
/**/