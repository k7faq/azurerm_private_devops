variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine."
  default     = "azureadmin"
  type = string
}
variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
  type = string
}
variable "admin_ssh_key" {
  description = "The SSH Key which should be used for the local-administrator on this Virtual Machine"
  default     = null
  type = string
}
variable "assign_public_ip_each_instance" {
  description = "Create a virtual machine scale set that assigns a public IP address to each VM"
  default     = false
  type = bool
}
variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to false."
  default     = false
  type = bool
}
variable "enable_automatic_instance_repair" {
  description = "Should the automatic instance repair be enabled on this Virtual Machine Scale Set?"
  default     = false
  type = bool
}
variable "availability_zones" {
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in"
  default     = null #[1, 2, 3]
  type = list
}
variable "availability_zone_balance" {
  description = "Should the Virtual Machines in this Scale Set be strictly evenly distributed across Availability Zones?"
  default     = false
  type = bool
}
variable "computer_name_prefix" {
  description = "(Required) Specifies the computer name prefix for all of the virtual machines in the scale set. Computer name prefixes must be 1 to 9 characters long. Changing this forces a new resource to be created."
  type = string
}
variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set."
  default     = null
}
variable "data_disks" {
  default = {}
  description = <<EOS
A map of configuration parameters to define additional disks to attach to this VM for data storage. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment

caching - (Required) Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite.

create_option - (Required) The method to use when creating the managed disk. Changing this forces a new resource to be created.

lun - (Required) The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine. Changing this forces a new resource to be created.

storage_account_type - (Required) The type of storage to use for the managed disk.

    ```hcl
    1 = {
      caching              = None, ReadOnly and ReadWrite.
      create_option        = Empty | Import | Copy | FromImage | Restore
      disk_size_gb         = number ,
      storage_account_type = Standard_LRS | StandardSSD_ZRS | Premium_LRS, Premium_ZRS | StandardSSD_LRS | UltraSSD_LRS
    }
    ```
EOS
  type = map(object({
    caching              = string
    create_option        = string
    disk_size_gb         = number
    storage_account_type = string
  }))
}
variable "do_not_run_extensions_on_overprovisioned_machines" {
  description = "Should Virtual Machine Extensions be run on Overprovisioned Virtual Machines in the Scale Set?"
  default     = false
  type = bool
}
variable "enable_boot_diagnostics" {
  description = "Should the boot diagnostics enabled?"
  default     = false
  type = bool
}
variable "enable_encryption_at_host" {
  description = " Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  default     = false
  type = bool
}
variable "enable_load_balancer" {
  description = "Controls if public load balancer should be created"
  default     = true
  type = bool
}
variable "enable_proximity_placement_group" {
  description = "Manages a proximity placement group for virtual machines, virtual machine scale sets and availability sets."
  default     = false
  type = bool
}
variable "grace_period" {
  description = "Amount of time (in minutes, between 30 and 90, defaults to 30 minutes) for which automatic repairs will be delayed."
  default     = "PT30M"
  type = string
}
 variable "image" {
   default = {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8"
    version   = "latest"
   }
   description = <<EOS
    Map of settings to define the image to use.
EOS
   type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
   })
  }
variable "instances_count" {
  description = "The number of Virtual Machines in the Scale Set."
  default     = 1
  type = number
}
variable "number_of_probes" {
  description = "The number of failed probe attempts after which the backend endpoint is removed from rotation. The default value is `2`. `NumberOfProbes` multiplied by `intervalInSeconds` value must be greater or equal to 10.Endpoints are returned to rotation when at least one probe is successful."
  default     = null
}
variable "lb_ports" {
  default = {
    frontend_port = 22
  backend_port = 22
  }
  description = <<-EOS
frontend_port - (Required) The port for the external endpoint. Port numbers for each Rule must be unique within the Load Balancer. Possible values range between 0 and 65534, inclusive.
backend_port - (Required) The port used for internal connections on the endpoint. Possible values range between 0 and 65535, inclusive.
EOS
  type = object({
    frontend_port = number
  backend_port = number
  })
}
variable "lb_private_ip_address" {
  description = "Private IP Address to assign to the Load Balancer."
  default     = null
}
variable "lb_probe_protocol" {
  description = "Specifies the protocol of the end point. Possible values are `Http`, `Https` or `Tcp`. If `Tcp` is specified, a received ACK is required for the probe to be successful. If `Http` is specified, a `200 OK` response from the specified `URI` is required for the probe to be successful."
  default     = null
}
variable "lb_probe_request_path" {
  description = "The URI used for requesting health status from the backend endpoint. Required if protocol is set to `Http` or `Https`. Otherwise, it is not allowed"
  default     = null
}
variable "load_balancer_health_probe_port" {
  description = "Port on which the Probe queries the backend endpoint. Default `443`"
  default     = 22
}
variable "load_balancer_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
  default     = "Standard"
  type = string
}
variable "load_balancer_type" {
  description = "Controls the type of load balancer should be created. Possible values are public and private"
  default     = "private"
}
variable "managed_identity_type" {
  default     = null
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine Scale Set. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  type = string
}
variable "managed_identity_ids" {
  default     = null
  description = " A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine Scale Set."
  type = list
}
variable "minimum_instances_count" {
  description = "The minimum number of instances for this resource. Valid values are between 0 and 1000"
  default     = 1
}
variable "os_disk" {
  default = {
    caching = "ReadWrite" # The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`
    disk_size_gb = 50 # The Size of the Internal OS Disk in GB.
    disk_encryption_set_id = null # The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. The Disk Encryption Set must have the `Reader` Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault
    write_accelerator_enabled = false # Should Write Accelerator be Enabled for this OS Disk? This requires that the `storage_account_type` is set to `Premium_LRS` and that `caching` is set to `None`.
    storage_account_type = "StandardSSD_LRS" # The Type of Storage Account which should back this the Internal OS Disk. Possible values include `Standard_LRS`, `StandardSSD_LRS` and `Premium_LRS`.
  }
  description = <<-STRING
  ```hcl
    caching = "ReadWrite" # The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`
    disk_size_gb = 30 # The Size of the Internal OS Disk in GB.
    disk_encryption_set_id = null # The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. The Disk Encryption Set must have the `Reader` Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault
    write_accelerator_enabled = false # Should Write Accelerator be Enabled for this OS Disk? This requires that the `storage_account_type` is set to `Premium_LRS` and that `caching` is set to `None`.
    storage_account_type = "StandardSSD_LRS" # The Type of Storage Account which should back this the Internal OS Disk. Possible values include `Standard_LRS`, `StandardSSD_LRS` and `Premium_LRS`.
  ```
  STRING
  type = object({
        caching = string
    disk_size_gb = number
    disk_encryption_set_id = string
    write_accelerator_enabled = bool
    storage_account_type = string
  })
}
variable "os_flavor" {
  description = "Specify the flavour of the operating system image to deploy VMSS. Valid values are `windows` and `linux`"
  type = string
}
variable "os_upgrade_mode" {
  description = "Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Automatic"
  default     = "Automatic"
  type = string
}
variable "overprovision" {
  description = "Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. You're not billed for these over-provisioned VM's and they don't count towards the Subscription Quota. Defaults to true."
  default     = false
  type = bool
}
variable "platform_fault_domain_count" {
  description = "Specifies the number of fault domains that are used by this Linux Virtual Machine Scale Set."
  default     = null
type = number
}
variable "private_ip_address_allocation_type" {
  description = "The allocation method for the Private IP Address used by this Load Balancer. Possible values as Dynamic and Static."
  default     = "Dynamic"
}
variable "provision_vm_agent" {
  default = true
  description = "(Optional) Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to true."
  type = bool
}
variable "public_ip" {
  default = {
         allocation_method = "Static"
    sku = "Standard"
    sku_tier = "Regional"
    domain_name_label = "bastion-blu"
  }
  description = <<-EOS
  ```hcl
  public_ip = {
    allocation_method = string # Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic`
    sku = string # The SKU of the Public IP. Accepted values are `Basic` and `Standard`
    sku_tier = string # The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`
    domain_name_label = string # Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
  }
  ```
  EOS
  type = object({
     allocation_method = string
    sku = string
    sku_tier = string
    domain_name_label = string
  })
}
variable "resource_group" {
  description = <<EOS
  ```hcl
     resource_group = {
      name     = azurerm_resource_group.vmss_blu.name
      location = azurerm_resource_group.vmss_blu.location
    }
  ```
  EOS
  type = object({
    name = string
    location = string
  })
}
variable "rolling_upgrade_policy" {
  description = "Enabling automatic OS image upgrades on your scale set helps ease update management by safely and automatically upgrading the OS disk for all instances in the scale set."
  type = object({
    max_batch_instance_percent              = number
    max_unhealthy_instance_percent          = number
    max_unhealthy_upgraded_instance_percent = number
    pause_time_between_batches              = string
  })
  default = {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 20
    pause_time_between_batches              = "PT0S"
  }
}
variable "scale_in_policy" {
  description = "The scale-in policy rule that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled in. Possible values for the scale-in policy rules are `Default`, `NewestVM` and `OldestVM`"
  default     = "Default"
  type = string
}
variable "single_placement_group" {
  description = "Allow to have cluster of 100 VMs only"
  default     = true
  type = bool
}
variable "sku" {
  default     = "Standard_B4ms"
  type        = string
  description = "(Required) The SKU which should be used for this Virtual Machine, such as Standard_F2.<br>az vm list-sizes --location eastus"
}
variable "source_image_id" {
  description = "The ID of an Image which each Virtual Machine in this Scale Set should be based on"
  default     = null
  type = string
}
variable "storage_account_uri" {
  default = null
  description = "(Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor."
  type = string
}
variable "subnet_id" {
  default = null
  description = "AzureRM Resource ID of subnet for internal network interfaces."
  type = string
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
variable "ultra_ssd_enabled" {
  description = "Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine"
  default     = false
  type = bool
}
variable "virtual_machine_size" {
  description = "The Virtual Machine SKU for the Scale Set, Default is Standard_B4ms"
  default     = "Standard_B4ms"
  type = string
}
variable "vmss_name" {
  description = "Name of the VMSS object (not the name of the computer instance)"
  type = string
}

