
variable "vnets" {
  default = {
    edge = {
      blu_grn                = "blu"
      cidr                   = "10.210.91.0/24"
      create_network_watcher = true
      subnets = {
        bastion = {
          prefixes                                       = ["10.210.91.0/28"]
          service_endpoints                              = []
          enforce_private_link_endpoint_network_policies = false
          enforce_private_link_service_network_policies  = false
          delegation                                     = []
          nsg_rules = [
            # To use defaults, use "" or [] (accordingly) without adding any values.
            {
              direction = "Inbound",
              name      = "ssh",
              priority  = "100",
              direction = "Inbound",
              access    = "Allow",
              protocol  = "Tcp",
              source_port_ranges = [],
              source_address_prefixes = [],
              source_application_security_group_ids = [],
              destination_address_prefixes = [
                "10.210.91.0/28"
              ],
              destination_port_ranges = [
                "22"
              ],
              destination_application_security_group_ids = [],
              description                                = ""
            },
          ]
        }
#        egress = {
#          prefixes                                       = ["10.210.91.16/28"]
#          service_endpoints                              = []
#          enforce_private_link_endpoint_network_policies = false
#          enforce_private_link_service_network_policies  = false
#          delegation                                     = []
#          nsg_rules = [
#            # To use defaults, use "" or [] (accordingly) without adding any values.
#            {
#              direction                                  = "Inbound",
#              name                                       = "proxy_allow",
#              priority                                   = "100",
#              direction                                  = "Inbound",
#              access                                     = "Allow",
#              protocol                                   = "Tcp",
#              source_port_ranges                         = [],
#              source_address_prefixes                    = [],
#              source_application_security_group_ids      = [],
#              destination_address_prefixes               = [],
#              destination_port_ranges                    = [],
#              destination_application_security_group_ids = [],
#              description                                = ""
#            },
#          ]
#        }
#        devops = {
#          prefixes = [
#          "10.210.91.64/26"]
#          service_endpoints                              = []
#          enforce_private_link_endpoint_network_policies = false
#          enforce_private_link_service_network_policies  = false
#
#          delegation = []
#
#          nsg_rules = [
#            # To use defaults, use "" or [] (accordingly) without adding any values.
#            {
#              direction = "Inbound",
#              name      = "weballow",
#              priority  = "100",
#              direction = "Inbound",
#              access    = "Allow",
#              protocol  = "Tcp",
#              source_port_ranges = [
#              "22"],
#              source_address_prefixes = [
#              "10.210.91.0/26"],
#              source_application_security_group_ids = [],
#              destination_address_prefixes = [
#              "0.0.0.0/0"],
#              destination_port_ranges                    = [],
#              destination_application_security_group_ids = [],
#              description                                = ""
#            },
#          ]
#        }
      }
    } # /edge
  }   # /default
  description = ""
  type = map(object({
    blu_grn                = string
    cidr                   = string
    create_network_watcher = bool
    subnets = map(object({
      prefixes                                       = list(string)
      service_endpoints                              = list(string)
      enforce_private_link_endpoint_network_policies = bool
      enforce_private_link_service_network_policies  = bool

      delegation = list(object({
        name = string
        service_delegation = list(object({
          name    = string
          actions = list(string)
        }))
      }))
      nsg_rules = list(object({
        direction                                  = string
        name                                       = string
        priority                                   = string
        direction                                  = string
        access                                     = string
        protocol                                   = string
        source_port_ranges                         = list(string)
        source_address_prefixes                    = list(string)
        source_port_ranges                         = list(string)
        source_application_security_group_ids      = list(string)
        destination_address_prefixes               = list(string)
        destination_port_ranges                    = list(string)
        destination_application_security_group_ids = list(string)
        description                                = string
      }))
    }))
  }))
}

module "vnet" {
  source = "./modules/azurerm-virtual-network"
  //  version = "2.2.0"

  logs_destinations_ids = [
    local.log_analytics_workspace.resource_id,
    azurerm_storage_container.security-scans.id
  ]
  resource_group = {
    name     = azurerm_resource_group.blu.name
    location = azurerm_resource_group.blu.location
  }
  tags = local.combined_tags

  for_each = { for key, value in var.vnets : key => value if value.blu_grn == "blu" }

  vnet_name          = join("-", [local.blu, each.key])
  vnet_address_space = [each.value.cidr]
  subnets            = each.value.subnets
}