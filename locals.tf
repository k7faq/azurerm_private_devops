
locals {
  base_name = join("-", [
    var.project.region_short,
    var.project.project,
    var.project.environment])

  blu = join("-", [
    local.base_name,
    "blu"])

  location = lookup(var.project, "region")

  log_analytics_workspace = {
    resource_id = azurerm_log_analytics_workspace.this.id
    name = azurerm_log_analytics_workspace.this.name
    location = azurerm_log_analytics_workspace.this.location
    workspace_id = azurerm_log_analytics_workspace.this.workspace_id
    resource_group_name = azurerm_resource_group.base.name
  }

  combined_tags = merge(var.required_tags,
  {
    Owner = "steven.rhodes@nuance.com"
  })
}