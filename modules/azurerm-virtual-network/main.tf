locals {
  tags = merge(var.tags, var.additional_tags)
}
#---------------------------------------------------------------
# Virtual Network
#---------------------------------------------------------------
resource "azurerm_virtual_network" "z" {
  name                = var.vnet_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  address_space       = var.vnet_address_space
  tags                = local.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos.plan_id == null ? [] : [var.ddos.plan_id]

    content {
      enable = var.ddos.enable
      id     = var.ddos.plan_id
    }
  }
}

resource "azurerm_subnet" "z" {
  for_each = var.subnets

  name                 = lower(each.key)
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.z.name
  address_prefixes     = each.value.prefixes
  service_endpoints    = each.value.service_endpoints

  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.enforce_private_link_service_network_policies

  dynamic "delegation" {
    for_each = each.value.delegation
    content {
      name = delegation.value.name
      dynamic "service_delegation" {
        for_each = delegation.value.service_delegation
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Network security group - NSG created for every subnet in VNet
#---------------------------------------------------------------
resource "azurerm_network_security_group" "z" {
  for_each            = var.subnets
  name                = lower(format("${var.vnet_name}-${each.key}-nsg"))
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = merge({ "ResourceName" = lower("nsg_${each.key}_in") }, local.tags, )

  dynamic "security_rule" {
    for_each = each.value.nsg_rules
    content {
      name                                       = security_rule.value.name == "" ? "Default_Rule" : security_rule.value.name
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
      access                                     = security_rule.value.access == "" ? "Allow" : security_rule.value.access
      protocol                                   = security_rule.value.protocol == "" ? "Tcp" : security_rule.value.protocol
      source_port_range                          = length(security_rule.value.source_port_ranges) == 0 ? "*" : ""
      source_port_ranges                         = length(security_rule.value.source_port_ranges) == 0 ? [] : security_rule.value.source_port_ranges
      destination_port_ranges                    = length(security_rule.value.destination_port_ranges) == 0 ? ["*"] : security_rule.value.destination_port_ranges
      source_address_prefix                      = length(security_rule.value.source_address_prefixes) == 0 ? "*" : ""
      source_address_prefixes                    = length(security_rule.value.source_address_prefixes) == 0 ? [] : security_rule.value.source_address_prefixes
      destination_address_prefixes               = length(security_rule.value.destination_address_prefixes) == 0 ? [azurerm_subnet.z[each.key].address_prefix] : security_rule.value.destination_address_prefixes
      source_application_security_group_ids      = length(security_rule.value.source_application_security_group_ids) == 0 ? null : security_rule.value.source_application_security_group_ids
      destination_application_security_group_ids = length(security_rule.value.destination_application_security_group_ids) == 0 ? null : security_rule.value.destination_application_security_group_ids
      description                                = security_rule.value.description
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "z" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.z[each.key].id
  network_security_group_id = azurerm_network_security_group.z[each.key].id
}

module "diagnostics" {
  source = "../diagnostic-settings"
  count = var.logs_destinations_ids == [] ? 0 : 1

  logs_destinations_ids = var.logs_destinations_ids
  resource_id           = azurerm_virtual_network.z.id
}
