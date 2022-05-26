
resource "azurerm_public_ip" "z" {
#  count               = var.public_ip != {} ? 1 : 0
  name                = "${var.vmss_name}-ip"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = var.public_ip.allocation_method
  sku                 = var.public_ip.sku
  sku_tier            = var.public_ip.sku_tier
  domain_name_label   = var.public_ip.domain_name_label
  tags                = var.tags
}

resource "azurerm_lb" "z" {
#  count               = var.enable_load_balancer ? 1 : 0
  name                = var.vmss_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = var.load_balancer_sku
  tags                = var.tags

  frontend_ip_configuration {
    name                          = var.vmss_name
    public_ip_address_id          = azurerm_public_ip.z.id
#    private_ip_address_allocation =  null
#    private_ip_address            =  null
#    subnet_id                     = var.public_ip == null ? var.subnet_id : null
  }
}

resource "azurerm_lb_backend_address_pool" "z" {
#  count           = var.enable_load_balancer ? 1 : 0
  name            = var.vmss_name
  loadbalancer_id = azurerm_lb.z.id
}
/*
resource "azurerm_lb_nat_pool" "z" {
  count                          = var.enable_load_balancer && var.enable_lb_nat_pool ? 1 : 0
  name                           = "${var.vmss_name}-lb-nat-pool"
  resource_group_name            = data.azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.z.0.id
  protocol                       = "Tcp"
  frontend_port_start            = var.nat_pool_frontend_ports[0]
  frontend_port_end              = var.nat_pool_frontend_ports[1]
  backend_port                   = var.os_flavor == "linux" ? 22 : 3389
  frontend_ip_configuration_name = azurerm_lb.vmsslb.0.frontend_ip_configuration.0.name
}

resource "azurerm_lb_probe" "z" {
#  count               = var.enable_load_balancer ? 1 : 0
  name                = var.vmss_name
  resource_group_name = azurerm_lb.z.resource_group_name
  loadbalancer_id     = azurerm_lb.z.id
  port                = var.load_balancer_health_probe_port
  protocol            = var.lb_probe_protocol
  request_path        = var.lb_probe_protocol != "Tcp" ? var.lb_probe_request_path : null
  number_of_probes    = var.number_of_probes
}

resource "azurerm_lb_rule" "z" {
#  count                          = var.enable_load_balancer ? length(var.load_balanced_port_list) : 0
  name                           = var.vmss_name
  resource_group_name            = azurerm_lb.z.resource_group_name
  loadbalancer_id                = azurerm_lb.z.id
  probe_id                       = azurerm_lb_probe.z.id
  protocol                       = "Tcp"
  frontend_port                  = var.lb_ports.frontend_port
  backend_port                   = var.lb_ports.backend_port
  frontend_ip_configuration_name = azurerm_lb.z.frontend_ip_configuration.0.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.z.id]
  load_distribution = "SourceIPProtocol"
}
/*
resource "azurerm_proximity_placement_group" "z" {
  count               = var.enable_proximity_placement_group ? 1 : 0
  name                = "${var.vmss_name}-prox-grp"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags
}
/*
resource "azurerm_network_security_group" "z" {
  count               = var.existing_network_security_group_id == null ? 1 : 0
  name                = "${var.vmss_name}-nsg-in"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags
}
*/
resource "azurerm_linux_virtual_machine_scale_set" "z" {
  count                                             = var.os_flavor == "linux" ? 1 : 0
  name                                              = var.vmss_name
  computer_name_prefix                              = var.computer_name_prefix
  resource_group_name                               = var.resource_group.name
  location                                          = var.resource_group.location
  sku                                               = var.sku
  instances                                         = var.instances_count
  admin_username                                    = var.admin_username
  admin_password                                    = var.admin_password != "" ? var.admin_password : null
  custom_data                                       = var.custom_data
  disable_password_authentication                   = var.admin_password == null ? true : false
  overprovision                                     = var.overprovision
  do_not_run_extensions_on_overprovisioned_machines = var.do_not_run_extensions_on_overprovisioned_machines
  encryption_at_host_enabled                        = var.enable_encryption_at_host
#  health_probe_id                                   = azurerm_lb_probe.z.id
  platform_fault_domain_count                       = var.platform_fault_domain_count
  provision_vm_agent                                = var.provision_vm_agent
  proximity_placement_group_id                      = null # TODO  var.enable_proximity_placement_group ? azurerm_proximity_placement_group.z.0.id : null
  scale_in_policy                                   = var.scale_in_policy
  single_placement_group                            = var.single_placement_group
  source_image_id                                   = var.source_image_id != null ? var.source_image_id : null
  upgrade_mode                                      = var.os_upgrade_mode
  zones                                             = var.availability_zones
  zone_balance                                      = var.availability_zone_balance
  tags                                              = var.tags

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key != "" && var.admin_password == null ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_key
    }
  }

  source_image_reference {
      publisher =  var.image["publisher"]
      offer     =  var.image["offer"]
      sku       =  var.image["sku"]
      version   =  var.image["version"]
  }

  os_disk {
    storage_account_type      = var.os_disk.storage_account_type
    caching                   = var.os_disk.caching
    disk_encryption_set_id    = var.os_disk.disk_encryption_set_id
    disk_size_gb              = var.os_disk.disk_size_gb
    write_accelerator_enabled = var.os_disk.write_accelerator_enabled
  }

  dynamic "additional_capabilities" {
    for_each = var.ultra_ssd_enabled ? [1] : []
    content {
      ultra_ssd_enabled = var.ultra_ssd_enabled
    }
  }

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      lun                  = data_disk.key
      disk_size_gb         = data_disk.value.disk_size_gb
      caching              = data_disk.value.caching
      create_option        = data_disk.value.create_option
      storage_account_type = data_disk.value.storage_account_type
    }
  }

 dynamic "automatic_os_upgrade_policy" {
    for_each = var.os_upgrade_mode == "Automatic" ? [1] : []
    content {
      disable_automatic_rollback  = true
      enable_automatic_os_upgrade = true
    }
  }

  network_interface {
    name                          = "${var.vmss_name}-nic"
    enable_accelerated_networking = var.enable_accelerated_networking
    primary   = true

    ip_configuration {
      name      = "${var.vmss_name}-ip-cfg"
      primary   = true
      subnet_id = var.subnet_id

      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.z.id]

      //        dynamic "public_ip_address" {
      //          for_each = var.assign_public_ip_each_instance ? [1] : []
      //          content {
      //            name                = "${var.vmss_name}-pubip-cfg"
      //            public_ip_prefix_id = var.public_ip_prefix_id
      //          }
      //        }
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.os_upgrade_mode != "Manual" ? [1] : []
    content {
      max_batch_instance_percent              = var.rolling_upgrade_policy.max_batch_instance_percent
      max_unhealthy_instance_percent          = var.rolling_upgrade_policy.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = var.rolling_upgrade_policy.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = var.rolling_upgrade_policy.pause_time_between_batches
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.enable_automatic_instance_repair ? [1] : []
    content {
      enabled      = var.enable_automatic_instance_repair
      grace_period = var.grace_period
    }
  }

  dynamic "identity" {
    for_each = var.managed_identity_type != null ? [1] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.storage_account_uri
    }
  }

  //  lifecycle {
  //    ignore_changes = [
  //      tags,
  //      automatic_instance_repair,
  //      automatic_os_upgrade_policy,
  //      rolling_upgrade_policy,
  //      instances,
  //      data_disk,
  //    ]
  //  }

  # As per the recomendation by Terraform documentation
# TODO   depends_on = [azurerm_lb_rule.z]
}


