 # -- Create Log Analytics Worksapce
 # Created in EastUS and WesstUS - controlled by the Resource Group

 # Create Log Analytics Workspace
 # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_service
 # https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html

 resource "azurerm_log_analytics_workspace" "this" {
   name                = join("-", [local.base_name, "loganalytics", random_string.str.result])
   location            = azurerm_resource_group.base.location
   resource_group_name = azurerm_resource_group.base.name
   retention_in_days   = 30 # 30 to 730.
   sku                 = "PerGB2018" # Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018
   tags                = merge(local.combined_tags, { description = "Log Aggregation" })
//   lifecycle {
//     prevent_destroy = true
//   }
 }

 resource "azurerm_log_analytics_solution" "container" {
   solution_name         = "ContainerInsights"
   location              = azurerm_resource_group.base.location
   resource_group_name   = azurerm_resource_group.base.name
   workspace_resource_id = azurerm_log_analytics_workspace.this.id
   workspace_name        = azurerm_log_analytics_workspace.this.name
   tags                  = merge(local.combined_tags, { description = "AKS" })

   plan {
     publisher = "Microsoft"
     product   = "OMSGallery/ContainerInsights"
   }
 }
