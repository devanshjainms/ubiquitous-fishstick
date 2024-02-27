# DO NOT MODIFY THESE RESOURCES
# Import the existing app service plan
resource "azurerm_service_plan" "app_service_plan" {
    name                        = format("%s-%s-appserviceplan", lower(var.environment), lower(var.location))
    location                    = azurerm_resource_group.rg.location
    resource_group_name         = azurerm_resource_group.rg.name
    os_type                     = "Linux" 
    sku_name                    = "Y1"
}

# Import the existing function app
resource "azurerm_linux_function_app" "function_app" {
    name                        = format("%s-%s-functionapp", lower(var.environment), lower(var.location))
    location                    = azurerm_resource_group.rg.location
    resource_group_name         = azurerm_resource_group.rg.name
    service_plan_id             = azurerm_service_plan.app_service_plan.id
    storage_account_name        = azurerm_storage_account.storage_account.name
    storage_account_access_key  = azurerm_storage_account.storage_account.primary_access_key
    https_only                  = true
    site_config {
        vnet_route_all_enabled  = true
    }
    app_settings                = {
        "FUNCTIONS_WORKER_RUNTIME" = "python"
        "WEBSITE_NODE_DEFAULT_VERSION" = "14"
        "AZURE_CLIENT_ID" = var.client_id
        "AZURE_CLIENT_SECRET" = var.client_secret
        "AZURE_TENANT_ID" = var.tenant_id
    }
}