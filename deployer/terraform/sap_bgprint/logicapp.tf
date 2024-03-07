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
                                value = "https://login.microsoftonline.com"
                            },
                            tenantId = {
                                value = var.tenant_id
                            },
                            resourceUri = {
                                value = "https://graph.microsoft.com"
                            },
                            enableOnbehalfOfLogin = {
                                value = "true"
                            }
                        }
                    }
                }
            },
            capabilities = [],
            description = "Microsoft Universal Print connector",
            displayName = format("%s-%s", lower(random_string.random.result), lower(var.location)),
            iconUri = "https://content.powerapps.com/resource/makerx/static/media/default-connection-icon.74fb37fa.svg",
            apiType = "Rest",
            swagger = {
                swagger = "2.0",
                info = {
                    title = format("%s-%s", lower(random_string.random.result), lower(var.location)),
                    version = "1.0.0"
                },
                host = "https://graph.microsoft.com",
                schemes = [
                    "https"
                ],
                paths = {
                    "/v1.0/me" = {
                        get = {
                            operationId = "GetMyProfile",
                            description = "Get my profile",
                            responses = {
                                "200" = {
                                    description = "Success"
                                }
                            }
                        }
                    }
                }
            },
            apiDefinitions = {
                swagger = "2.0",
                info = {
                    title = format("%s-%s", lower(random_string.random.result), lower(var.location)),
                    version = "1.0.0"
                },
                host = "https://graph.microsoft.com",
                schemes = [
                    "https"
                ],
                paths = {
                    "/v1.0/me" = {
                        get = {
                            operationId = "GetMyProfile",
                            description = "Get my profile",
                            responses = {
                                "200" = {
                                    description = "Success"
                                }
                            }
                        }
                    }
                }
            }
        }
    })
}