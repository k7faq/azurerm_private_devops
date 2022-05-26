resource "azurerm_storage_account" "general" {
  account_replication_type          = "ZRS"
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  enable_https_traffic_only         = true
  infrastructure_encryption_enabled = true
  min_tls_version                   = "TLS1_2"
  location                          = azurerm_resource_group.base.location
  name                              = replace("${local.base_name}-${random_string.str.result}", "-", "")
  resource_group_name               = azurerm_resource_group.base.name
  tags                              = local.combined_tags

  //  network_rules {
  //    default_action = "Deny"
  //    virtual_network_subnet_ids = [
  //      azurerm_virtual_network.peered.id,
  //      azurerm_virtual_network.core_cluster_01.id
  //    ]
  //  }
}

# Storage Container for Security Logs
resource "azurerm_storage_container" "security-scans" {
  name                  = "security-scans"
  storage_account_name  = azurerm_storage_account.general.name
  container_access_type = "private"
}

module "diagnostic_settings" {
  source  = "./modules/diagnostic-settings"

  resource_id = azurerm_storage_account.general.id

  logs_destinations_ids = [
    azurerm_storage_account.general.id,
    azurerm_log_analytics_workspace.this.workspace_id
  ]
  log_analytics_destination_type = "Dedicated"
}
