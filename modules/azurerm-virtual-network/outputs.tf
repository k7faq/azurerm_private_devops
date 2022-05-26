# Vnet and Subnets
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.z.name
}
output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = azurerm_virtual_network.z.id
}
output "virtual_network_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.z.location
}
output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = azurerm_virtual_network.z.address_space
}
output "subnet_ids" {
  description = "map of subnet names to subnet IDs"
  value = merge({
    for n, s in azurerm_subnet.z : n => s.id
  })
}
output "subnet_names" {
  description = "map of subnet names to subnet IDs"
  value = merge({
    for n, s in azurerm_subnet.z : n => s.name
  })
}
output "subnet_address_prefixes" {
  description = "map of subnet names to subnet address prefixes"
  value = merge({
    for n, s in azurerm_subnet.z : n => s.address_prefix
  })
}
# Network Security group ids
output "network_security_group_ids" {
  description = "List of Network security groups and ids"
  value       = merge({
    for n, s in azurerm_network_security_group.z : n => s.id
  })
}
