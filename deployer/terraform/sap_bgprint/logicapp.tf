# Logic app custom connector
resource "azapi_resource" "symbolicname" {
    type                = "Microsoft.Web/customApis@2016-06-01"
    name                = format("%s-%s", lower(random_string.random.result), lower(var.location))
    location            = var.location
    schema_validation_enabled = false
    parent_id           = azurerm_resource_group.rg.id 
    body                = jsonencode({
        properties= {
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
            apiType = "Rest",
            swagger = {
                host = var.graph_resource_uri
                basePath = "/"
                consumes = []
                parameters = []
                produces = []

                schemes = [
                    "https"
                ]
                swagger = "2.0"
                definitions = {
                    "microsoft.graph.printer" = {
                        type = "object"
                        properties = {
                            id = {
                                type = "string"
                            },
                            displayName = {
                                type = "string"
                            },
                            manufacturer = {
                                type = "string"
                            },
                            model = {
                                type = "string"
                            },
                            physicalDeviceId = {
                                type = "string"
                            },
                            physicalDeviceLocation = {
                                type = "string"
                            },
                            physicalDeviceName = {
                                type = "string"
                            },
                            physicalDeviceType = {
                                type = "string"
                            },
                            status = {
                                type = "string"
                            }
                        }
                    }
                }
                paths = {
                    "/v1.0/print/shares" = {
                        get = {
                            description = "Get printers"
                            operationId = "Printers_Get"
                            parameters = [
                                {
                                    name = "operation"
                                    in = "path"
                                    required = true
                                    type = "string"
                                },
                                {
                                    name = "body"
                                    in = "body"
                                    required = true
                                    schema = {
                                        type = "object"
                                    }
                                }
                            ]
                            responses = {
                                "200": {
                                    "description": "List of printers",
                                    "schema": {
                                    "type": "array",
                                    "items": {
                                        "$ref": "#/definitions/microsoft.graph.printer"
                                    }
                                    }
                                },
                                "400": {
                                    "description": "BadRequest"
                                },
                                "401": {
                                    "description": "Unauthorized"
                                },
                                "403": {
                                    "description": "Forbidden"
                                },
                                "500": {
                                    "description": "InternalServerError"
                                }
                            }
                        }
                    }
                }
                }
            backendService= {
                serviceUrl= var.graph_resource_uri
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
