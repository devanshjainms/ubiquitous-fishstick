# DO NOT MODIFY THESE RESOURCES
# Import the existing app service plan

resource "azurerm_service_plan" "app_service_plan" {
    name                                = format("%s-%s-appserviceplan", lower(var.environment), lower(var.location))
    location                            = azurerm_resource_group.rg.location
    resource_group_name                 = azurerm_resource_group.rg.name
    sku_name                            = "EP1"
    os_type                             = "Linux"
    maximum_elastic_worker_count        = 5
}

# Import the existing function app
resource "azurerm_linux_function_app" "function_app" {
    name                                = format("%s-%s-functionapp", lower(var.environment), lower(var.location))
    location                            = azurerm_resource_group.rg.location
    resource_group_name                 = azurerm_resource_group.rg.name
    service_plan_id                     = azurerm_service_plan.app_service_plan.id
    storage_account_name                = azurerm_storage_account.storage_account.name
    storage_account_access_key          = azurerm_storage_account.storage_account.primary_access_key
    functions_extension_version         = "~4"
    client_certificate_mode             = "Required"
    https_only                          = true
    virtual_network_subnet_id           = azurerm_subnet.subnet.id
    identity {
        type                            = "SystemAssigned"
    }
    site_config {
        container_registry_use_managed_identity = true
        ftps_state                      = "FtpsOnly"
        vnet_route_all_enabled          = true
        elastic_instance_minimum        = 1
        cors {
            allowed_origins             = ["https://portal.azure.com"]
            support_credentials         = false
        }
        # ip_restriction {
        #     action                      = "Allow"
        #     virtual_network_subnet_id   = azurerm_subnet.subnet.id
        # }
        # scm_ip_restriction {
        #     action                      = "Allow"
        #     virtual_network_subnet_id   = azurerm_subnet.subnet.id 
        # }
        # ip_restriction_default_action   = "Allow"
        # scm_ip_restriction_default_action = "Allow"
        application_stack {
            docker {
                image_name              = var.container_image_name
                image_tag               = "latest"
                registry_url            = format("https://%s", var.container_registry_url)
            }
        }
    }
    app_settings                        = {
        "AzureWebJobsStorage"           = azurerm_storage_account.storage_account.primary_connection_string
        "AzureWebJobsDashboard"         = azurerm_storage_account.storage_account.primary_connection_string
        "WEBSITE_LOGGING_LOG_LEVEL"     = "Information"
        "AzureFunctionsJobHost__Logging__Console__IsEnabled"         = "true"
        "AzureFunctionsJobHost__Logging__Console__LogLevel__Default" = "Information"
        "FUNCTIONS_WORKER_RUNTIME"      = "python"
        "FUNCTIONS_EXTENSION_VERSION"   = "~4"
        "WEBSITE_WEBDEPLOY_USE_SCM"     = true
        "WEBSITES_ENABLE_APP_SERVICE_STORAGE"                        = false
        "DOCKER_REGISTRY_SERVER_URL"    = format("https://%s", var.container_registry_url)
        "DOCKER_CUSTOM_IMAGE_NAME"      = "bgprinting:latest"
        "DOCKER_REGISTRY_SERVER_USERNAME" = null
        "DOCKER_REGISTRY_SERVER_PASSWORD" = null
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
