# DO NOT MODIFY THESE RESOURCES
# Import the existing app service plan

resource "azurerm_app_service_plan" "app_service_plan" {
    name                = format("%s-%s-appserviceplan", lower(var.environment), lower(var.location))
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    kind                = "elastic"
    reserved            = true
    is_xenon            = false
    zone_redundant      = false
    maximum_elastic_worker_count = 5
    sku {
        tier = "ElasticPremium"
        size = "EP1"
        capacity = 1
    }
}

# Import the existing function app
resource "azurerm_linux_function_app" "function_app" {
    name                                = format("%s-%s-functionapp", lower(var.environment), lower(var.location))
    location                            = azurerm_resource_group.rg.location
    resource_group_name                 = azurerm_resource_group.rg.name
    service_plan_id                     = azurerm_app_service_plan.app_service_plan.id
    storage_account_name                = azurerm_storage_account.storage_account.name
    storage_uses_managed_identity       = true
    webdeploy_publish_basic_authentication_enabled = true
    ftp_publish_basic_authentication_enabled = true
    https_only                          = true
    virtual_network_subnet_id           = azurerm_subnet.subnet.id
    identity {
        type                            = "SystemAssigned"
    }
    site_config {
        ftps_state                      = "FtpsOnly"
        vnet_route_all_enabled          = true
        container_registry_use_managed_identity = true
        elastic_instance_minimum        = 1
        cors {
            allowed_origins             = ["https://portal.azure.com"]
            support_credentials         = false
        }
        application_stack {
            python_version              = "3.10" 
            docker {
                image_name              = var.container_image_name
                image_tag               = "latest"
                registry_url            = format("https://%s", var.container_registry_url)
            }
        }
    }
    app_settings                        = {
        "FUNCTIONS_WORKER_RUNTIME"      = "python"
        "DOCKER_REGISTRY_SERVER_URL"    = format("https://%s", var.container_registry_url)
        "WEBSITE_NODE_DEFAULT_VERSION"  = "14"
        "AZURE_CLIENT_ID"               = var.client_id
        "AZURE_CLIENT_SECRET"           = var.client_secret
        "AZURE_TENANT_ID"               = var.tenant_id
        "STORAGE_ACCESS_KEY"            = azurerm_storage_account.storage_account.primary_connection_string
        "STORAGE_QUEUE_NAME"            = azurerm_storage_queue.queue.name
        "STORAGE_CONTAINER_NAME"        = azurerm_storage_container.container.name
        "LOGIC_APP_URL"                 = azurerm_logic_app_trigger_http_request.logic_app_trigger.callback_url
        "KEY_VAULT_NAME"                = azurerm_key_vault.kv.name
        "STORAGE_TABLE_NAME"            = azurerm_storage_table.table.name
    }
}
