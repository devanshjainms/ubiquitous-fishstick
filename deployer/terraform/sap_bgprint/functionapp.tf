# DO NOT MODIFY THESE RESOURCES
# Import the existing app service plan
resource "azurerm_service_plan" "app_service_plan" {
    name                        = format("%s-%s-appserviceplan", lower(var.environment), lower(var.location))
    location                    = azurerm_resource_group.rg.location
    resource_group_name         = azurerm_resource_group.rg.name
    os_type                     = "Linux" 
    sku_name                    = "EP1"
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
        container_registry_use_managed_identity = true
        always_on               = true 
        elastic_instance_minimum = 1
        application_stack {
            docker {
                image_name      = var.container_image_name
                image_tag       = "latest"
                registry_url    = var.container_registry_url
            }
        }
    }
    auth_settings {
        enabled                 = true
        microsoft {
            client_id           = var.client_id
            client_secret       = var.client_secret
        }
    }
    app_settings                        = {
        "FUNCTIONS_WORKER_RUNTIME"      = "python"
        "DOCKER_REGISTRY_SERVER_URL"    = var.container_registry_url
        "WEBSITE_NODE_DEFAULT_VERSION"  = "14"
        "AZURE_CLIENT_ID"               = var.client_id
        "AZURE_CLIENT_SECRET"           = var.client_secret
        "AZURE_TENANT_ID"               = var.tenant_id
        "STORAGE_ACCESS_KEY"            = azurerm_storage_account.storage_account.primary_access_key
        "STORAGE_QUEUE_NAME"            = azurerm_storage_queue.queue.name
        "STORAGE_CONTAINER_NAME"        = azurerm_storage_container.container.name
        "LOGIC_APP_URL"                 = azurerm_logic_app_trigger_http_request.logic_app_trigger.callback_url
        "KEY_VAULT_NAME"                = azurerm_key_vault.kv.name
        "STORAGE_TABLE_NAME"            = azurerm_storage_table.table.name
    }
}