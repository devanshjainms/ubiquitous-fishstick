# Import the existing resource group
resource "azurerm_resource_group" "rg" {
    name                        = format("%s-%s-RG", upper(var.environment), upper(var.location))
    location                    = var.location
    tags                        = var.resource_group_tags
}

# Import the existing managed identity
resource "azurerm_user_assigned_identity" "msi" {
    name                        = format("%s-%s-msi", lower(var.environment), lower(var.location))
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = azurerm_resource_group.rg.location
}

#create a subnet in the virtual network
resource "azurerm_subnet" "subnet" {
    name                        = format("bgprint-subnet")
    resource_group_name         = split("/", var.virtual_network_id)[4]
    virtual_network_name        = split("/", var.virtual_network_id)[8]
    delegation {
        name                    = "delegation"
        service_delegation {
            name                = "Microsoft.Web/serverFarms"
        }
    }
    address_prefixes            = [var.subnet_address_prefixes]
    service_endpoints           = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Web"] 
}

# Import the existing key vault
resource "azurerm_key_vault" "kv" {
    name                        = format("%s%s%s", lower(var.environment), lower(var.location), lower("kv"))
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = azurerm_resource_group.rg.location
    enabled_for_disk_encryption = true
    purge_protection_enabled    = false
    tenant_id                   = var.tenant_id
    sku_name                    = "standard"
    access_policy {
        tenant_id               = var.tenant_id
        object_id               = var.object_id
        secret_permissions      = [
            "Get",
            "List"
        ]
        key_permissions         = [
            "Get",
            "List",
            "Create"
        ]    
    }
    public_network_access_enabled = false
    network_acls {
        default_action          = "Deny"
        bypass                  = "AzureServices"
        virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
    }
    lifecycle {
        ignore_changes = [
            access_policy,
            network_acls
        ]
    }
}
