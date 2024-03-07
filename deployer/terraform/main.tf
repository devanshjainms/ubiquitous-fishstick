
terraform {
    backend "azurerm" {}
}

module "sap_bgprint" {
    source                  = "./sap_bgprint"
    providers               = {
                                azurerm.main           = azurerm.main
                                azapi.api              = azapi.api
                            }

    client_id               = var.client_id
    client_secret           = var.client_secret
    subscription_id         = var.subscription_id
    tenant_id               = var.tenant_id
    resource_group_name     = var.resource_group_name
    location                = var.location
    virtual_network_id      = var.virtual_network_id
    subnet_address_prefixes = var.subnet_address_prefixes
    environment             = var.environment
    object_id               = var.object_id
    resource_group_tags     = var.resource_group_tags
}