# Logic app custom connector
resource "azurerm_template_deployment" "name" {
    name                = "deploymentname"
    resource_group_name = azurerm_resource_group.rg.name
    deployment_mode     = "Incremental"
    parameters          = {
        customApis_UPGraphAPIConnector_name = "CustomAPIConnector"
        location                            = var.location
    }
    template_body       = <<DEPLOY
    
        {
        "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "variables": {},
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
                                "clientId": "341292a1-95e2-440e-96e5-731c03d21132",
                                "scopes": [],
                                "properties": {},
                                "customParameters": {
                                    "loginUri": {
                                        "value": "https://login.microsoftonline.com"
                                    },
                                    "tenantId": {
                                        "value": "common"
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
                    "apiType": "Rest",
                    "wsdlDefinition": {}
                }
            }
        ]
    }
    DEPLOY
}