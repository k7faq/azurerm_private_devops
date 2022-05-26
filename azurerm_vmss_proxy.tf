# Unique backdoor password for default admin - will be used for break glass and initial startup
resource "random_password" "vmss_proxy_admin" {
  length      = 20
  min_special = 3
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
}

resource "azurerm_key_vault_secret" "vmss_proxy_admin" {
  key_vault_id = module.keyvault_infra.key_vault_id
  name         = "vmss-proxy-admin"
  value        = random_password.vmss_proxy_admin.result
  tags         = {}
}

module "vmss_proxy" {
  source = "./modules/azurerm-vm-scale-sets"
  #  version = "2.3.0"

  vmscaleset_name = join("-", [local.blu, "vmss", random_string.str.result])

  resource_group = {
    name     = azurerm_resource_group.vmss_blu.name
    location = azurerm_resource_group.vmss_blu.location
  }
  storage_account = {
    name = azurerm_storage_account.general.name
    uri  = azurerm_storage_account.general.primary_web_endpoint
    id   = azurerm_storage_account.general.id
  }
  subnet = {
    name = module.vnet["proxy"].subnet_names["proxy"]
    id   = module.vnet["proxy"].subnet_ids["proxy"]
  }
  virtual_network = {
    name = module.vnet["proxy"].virtual_network_name
    id   = module.vnet["proxy"].virtual_network_id
  }

  os_flavor                       = "linux"
  linux_distribution_name         = "ubuntu2004"
  virtual_machine_size            = "Standard_B4ms"
  admin_username                  = azurerm_key_vault_secret.vmss_proxy_admin.name
  admin_password                  = azurerm_key_vault_secret.vmss_proxy_admin.value
  disable_password_authentication = false
  generate_admin_ssh_key          = false
  instances_count                 = 1

  enable_proximity_placement_group    = false
  assign_public_ip_to_each_vm_in_vmss = false
  enable_automatic_instance_repair    = true

  load_balancer_type              = "private"
  load_balancer_health_probe_port = 3588
  load_balanced_port_list         = [3588]
  additional_data_disks           = []

  enable_autoscale_for_vmss          = true
  minimum_instances_count            = 1
  maximum_instances_count            = 5
  scale_out_cpu_percentage_threshold = 80
  scale_in_cpu_percentage_threshold  = 20

  enable_boot_diagnostics            = true
  existing_network_security_group_id = module.vnet["proxy"].network_security_group_ids["proxy"]

  managed_identity_typ= "SystemAssigned"

  extensions = {
#    AADSSHLogin = {
#      protected_settings   = ""
#      publisher            = "Microsoft.Azure.ActiveDirectory"
#      settings             = ""
#      type                 = "AADSSHLoginForLinux"
#      type_handler_version = "1.0"
#    }
    #    - autoUpgradeMinorVersion: true
    #      enableAutomaticUpgrade: null
    #      forceUpdateTag: null
    #      id: null
    #      name: AADSSHLogin
    #      protectedSettings: null
    #      protectedSettingsFromKeyVault: null
    #      provisionAfterExtensions: null
    #      provisioningState: null
    #      publisher: Microsoft.Azure.ActiveDirectory
    #      settings: null
    #      suppressFailures: null
    #      type: null
    #      typeHandlerVersion: '1.0'
    #      typePropertiesType: AADSSHLoginForLinux
    monitor = {
      protected_settings   = ""
      publisher            = "Microsoft.Azure.Monitoring.DependencyAgent"
      settings             = ""
      type                 = "DependencyAgentLinux"
      type_handler_version = "9.10" # 9.10.12.18430
    }
    #    oms_agent = {
    #      publisher            = "Microsoft.EnterpriseCloud.Monitoring"
    #      type                 = "OmsAgentForLinux"
    #      type_handler_version = "1.7" # WHY? This is 1.12 in dev and staging
    #      settings             = <<SETTINGS
    #    {
    #      "workspaceId": "${local.log_analytics_workspace.workspace_id}"
    #    }
    #
    #SETTINGS
    #      protected_settings   = <<PROTECTED_SETTINGS
    #    {
    #     "workspaceKey": "${local.log_analytics_workspace.primary_shared_key}"
    #    }
    #
    #PROTECTED_SETTINGS
    #    }
  }


  #  network_interfaces = {
  #    primary = {
  #      enable_accelerated_networking = false
  #      ip_configuration = {
  #        static_private_ip_address   = "10.23.138.30"
  #        static_public_ip_address_id = null
  #        primary                     = true
  #      }
  #    }
  #  }
}

/*
module "vmss_bastion" {
  source  = "./modules/azurerm-virtual-machine-scale-sets"
//  version = "1"
  depends_on = [azurerm_key_vault_secret.vmss_proxy_admin]

  vmss_name            = join("-", [local.blu, "vmss", random_string.str.result])
  availability_zones   = [1, 2, 3]
  computer_name_prefix = "test"
  os_flavor            = "linux"
  os_upgrade_mode = "Manual"
  resource_group       = { name = azurerm_resource_group.vmss_blu.name, location = azurerm_resource_group.vmss_blu.location }
  subnet_id = module.vnet["proxy"].subnet_ids["bastion"]
admin_password = azurerm_key_vault_secret.vmss_proxy_admin.value
  admin_username = azurerm_key_vault_secret.vmss_proxy_admin.name
  admin_ssh_key = null
  scale_in_policy = "OldestVM"
  tags = merge(local.combined_tags, {Role = "Bastion Ingress"})
}
/**/