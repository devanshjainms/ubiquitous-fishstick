# Logic app custom connector
resource "azapi_resource" "symbolicname" {
    type                = "Microsoft.Web/customApis@2016-06-01"
    name                = format("%s-%s", lower(random_string.random.result), lower(var.location))
    location            = var.location
    schema_validation_enabled = false
    parent_id           = azurerm_resource_group.rg.id 
    body                = jsonencode({
        properties= {
            backendService= {
                serviceUrl= var.graph_resource_uri
            }
            connectionParameters= {
                token= {
                    type= "oauthSetting",
                    oAuthSettings= {
                        identityProvider= "aad",
                        clientId = var.client_id,
                        scopes = [],
                        properties = {},
                        customParameters = {
                            loginUri = {
                                value = var.microsoft_login_uri
                            },
                            tenantId = {
                                value = var.tenant_id
                            },
                            resourceUri = {
                                value = var.graph_resource_uri
                            },
                            enableOnbehalfOfLogin = {
                                value = "true"
                            }
                        }
                    }
                }
            },
            capabilities = [],
            description = var.connector_description,
            displayName = format("%s-%s", lower("upconnector"), lower(var.location)),
            iconUri = "https://content.powerapps.com/resource/makerx/static/media/default-connection-icon.74fb37fa.svg",
            apiType = "Rest"
            apiDefinition = {
                type = "swagger",
                specification = {
                    type = "openapi",
                    definition = <<DEFINITION
                        {
                            "swagger": "2.0",
                            "info": {
                                "title": "Microsoft Graph",
                                "version": "v1.0"
                            },
                            "host": "graph.microsoft.com",
                            "schemes": [
                                "https"
                            ],
                            "paths": {
                                "/me": {
                                    "get": {
                                        "operationId": "GetMyProfile",
                                        "responses": {
                                            "200": {
                                                "description": "Success"
                                            }
                                        }
                                    }
                                }
                            },
                            "definitions": {
                                "User": {
                                    "type": "object",
                                    "properties": {
                                        "id": {
                                            "type": "string"
                                        },
                                        "displayName": {
                                            "type": "string"
                                        }
                                    }
                                }
                            }
                        }
                    DEFINITION
                }
            }
            
        }
    })
}

resource "azurerm_logic_app_workflow" "logic_app" {
    name                = format("%s%s-logicapp", lower(var.environment), lower(var.location))
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    workflow_version    =  "1.0.0.0"
    workflow_schema     = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
}

resource "azurerm_logic_app_trigger_http_request" "logic_app_trigger" {
    name                = "FunctionAppCallee"
    logic_app_id        = azurerm_logic_app_workflow.logic_app.id 
    method              = "POST"
    schema              = <<SCHEMA
    {
        "type": "object",
        "properties": {
            "body": {
                "type": "object",
                "properties": {
                    "message": {
                        "type": "string"
                    }
                }
            }
        }
    }
    SCHEMA 
}

# resource "azurerm_logic_app_action_custom" "parse_json" {
#     name                = "Create Print Job"
#     logic_app_id        = azurerm_logic_app_workflow.logic_app.id
#     body                = jsonencode({
#         "inputs": {
#             "method": "post",
#             "path": azurerm_logic_app_trigger_http_request.logic_app_trigger.callback_url,
#             "headers": {
#                 "Content-Type": "application/json"
#             },
#             "body": {
#                 "configuration": "@{triggerOutputs()['body']['message']}"
#             }
#         },
#     }) 
# }
