module "keyvault_infra" {
  source  = "kumarvna/key-vault/azurerm"
  version = "2.2.0"
# By default, this module will not create a resource group and expect to provide
  # a existing RG name to use an existing resource group. Location will be same as existing RG.
  # set the argument to `create_resource_group = true` to create new resrouce.
  resource_group_name        = azurerm_resource_group.base.name
  key_vault_name             = "${local.base_name}-infra"
  key_vault_sku_pricing_tier = "standard"

  # Once `Purge Protection` has been Enabled it's not possible to Disable it
  # Deleting the Key Vault with `Purge Protection` enabled will schedule the Key Vault to be deleted
  # The default retention period is 90 days, possible values are from 7 to 90 days
  # use `soft_delete_retention_days` to set the retention period
  enable_purge_protection = false
  # soft_delete_retention_days = 90

  # Access policies for users, you can provide list of Azure AD users and set permissions.
  # Make sure to use list of user principal names of Azure AD users.
  access_policies = [
#    {
#      azure_ad_user_principal_names = ["user1@example.com", "user2@example.com"]
#      key_permissions               = ["get", "list"]
#      secret_permissions            = ["get", "list"]
#      certificate_permissions       = ["get", "import", "list"]
#      storage_permissions           = ["backup", "get", "list", "recover"]
#    },

    # Access policies for AD Groups
    # to enable this feature, provide a list of Azure AD groups and set permissions as required.
#    {
#      azure_ad_group_names    = ["ADGroupName1", "ADGroupName2"]
#      key_permissions         = ["get", "list"]
#      secret_permissions      = ["get", "list"]
#      certificate_permissions = ["get", "import", "list"]
#      storage_permissions     = ["backup", "get", "list", "recover"]
#    },

    # Access policies for Azure AD Service Principlas
    # To enable this feature, provide a list of Azure AD SPN and set permissions as required.
#    {
#      azure_ad_service_principal_names = ["azure-ad-dev-sp1", "azure-ad-dev-sp2"]
#      key_permissions                  = ["get", "list"]
#      secret_permissions               = ["get", "list"]
#      certificate_permissions          = ["get", "import", "list"]
#      storage_permissions              = ["backup", "get", "list", "recover"]
#    }
  ]

  # Create a required Secrets as per your need.
  # When you Add `usernames` with empty password this module creates a strong random password
  # use .tfvars file to manage the secrets as variables to avoid security issues.
  secrets = {
#    "message" = "Hello, world!"
#    "vmpass"  = ""
  }

  log_analytics_workspace_id = null
  storage_account_id         = null

  # Adding additional TAG's to your Azure resources
  tags = local.combined_tags
}