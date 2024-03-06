# Logic app custom connector
resource "azurerm_resource_group_template_deployment" "name" {
    name                = "deploymentname"
    resource_group_name = azurerm_resource_group.rg.name
    deployment_mode     = "Incremental"
    parameters_content  = jsonencode({
        "customApis_UPGraphAPIConnector_name" = {
            value = "CustomAPIConnector"
        },
        "location"                            = {
            value = var.location
        },
        "tenantId"                            = {
            value = var.tenant_id
        },
        "clientId"                            = {
            value = var.client_id
        }
    })
    template_content = <<TEMPLATE
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "variables": {},
        "parameters": {
            "customApis_UPGraphAPIConnector_name": {
                "type": "string"
            },
            "location": {
                "type": "string"
            },
            "tenantId": {
                "type": "string"
            },
            "clientId": {
                "type": "string"
            }
        },
        "resources": [
            {
                "type": "Microsoft.Web/customApis",
                "apiVersion": "2016-06-01",
                "name": "[parameters('customApis_UPGraphAPIConnector_name')]",
                "location": "[parameters('location')]",
                "properties": {
                    "connectionParameters": {
                        "token": {
                            "type": "oauthSetting",
                            "oAuthSettings": {
                                "identityProvider": "aad",
                                "clientId": "[parameters('clientId')]",
                                "scopes": [],
                                "properties": {},
                                "customParameters": {
                                    "loginUri": {
                                        "value": "https://login.microsoftonline.com"
                                    },
                                    "tenantId": {
                                        "value": "[parameters('tenantId')]"
                                    },
                                    "resourceUri": {
                                        "value": "https://graph.microsoft.com"
                                    },
                                    "enableOnbehalfOfLogin": {
                                        "value": "true"
                                    }
                                }
                            }
                        }
                    },
                    "capabilities": [],
                    "description": "Microsoft Universal Print connector",
                    "displayName": "[parameters('customApis_UPGraphAPIConnector_name')]",
                    "iconUri": "https://content.powerapps.com/resource/makerx/static/media/default-connection-icon.74fb37fa.svg",
                    "apiType": "Rest"
                }
            }
        ]
    }
    TEMPLATE
}