variable "logs_destinations_ids" {
  description = "List of ID URI Strings of destinations to send Logs."
  type = list(string)
}

variable "resource_group" {
  description = <<EOS
EOS
  type = object({
    name = string
    location = string
  })
}

variable "subnets" {
  description = <<EOS
  create a subnet with a given address space, service endpoints, nsg rules, and service delegations
  ```hcl
    edge = {
      prefixes                                       = ["10.210.91.0/26"]
      service_endpoints                              = [] Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web.
      enforce_private_link_endpoint_network_policies = false
      enforce_private_link_service_network_policies  = false

      delegation = []

      nsg_rules = [
        # To use defaults, use "" or [] (accordingly) without adding any values.
        {
          direction                                  = "Inbound",
          name                                       = "weballow",
          priority                                   = "100",
          direction                                  = "Inbound",
          access                                     = "Allow",
          protocol                                   = "Tcp",
          source_port_ranges                         = [],
          source_address_prefixes                    = [],
          source_port_ranges                         = [],
          source_application_security_group_ids      = [],
          destination_address_prefixes               = ["0.0.0.0/0"],
          destination_port_ranges                    = ["443", "80"],
          destination_application_security_group_ids = [],
          description                                = ""
        },
      ]
    }
  ```
  EOS

    type = map(object({
      prefixes = list(string)
      service_endpoints = list(string)
      enforce_private_link_endpoint_network_policies = bool
      enforce_private_link_service_network_policies=bool

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
          source_address_prefixes                    = list(string)
          source_address_prefixes                    = list(string)
          source_port_ranges                         = list(string)
          source_application_security_group_ids      = list(string)
          destination_address_prefixes               = list(string)
          destination_port_ranges                    = list(string)
          destination_application_security_group_ids = list(string)
          description                                = string
      }))
    }))
  default = {}
}

variable "tags" {
  description = "Map of Key Value Pairs for Tags"
  type = map(string)
}

variable "additional_tags" {
  default = {}
  description = "Map of Additional Tag Key Value Pairs. Can also be used to override common tags."
  type = map(string)
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
}

#########################################################
### Security Settings
#########################################################
variable "ddos" {
  default = {
    enable = false
    plan_id = null
  }
  description = <<EOS
  Controls whether VNets have standard DDOS protection
  ```hcl
  ddos = {
    enable  = false
    plan_id = string
  }
  ```
  EOS
}
