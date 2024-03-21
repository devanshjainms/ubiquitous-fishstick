# Logic app custom connector
resource "azapi_resource" "custom_connector" {
    type                = "Microsoft.Web/customApis@2016-06-01"
    name                = format("%s-%s", lower(var.location), lower(random_string.random.result))
    location            = var.location
    schema_validation_enabled = false
    parent_id           = azurerm_resource_group.rg.id 
    body                = jsonencode({
        properties= {
            backendService          = {
                serviceUrl          = var.graph_resource_uri
            },
            connectionParameters    = {
                token               = {
                    type            = "oauthSetting",
                    oAuthSettings= {
                        identityProvider    = "aad",
                        clientId            = azuread_application_registration.app.id,
                        clientSecret        = azuread_application_password.password.value,
                        scopes              = [],
                        properties          = {},
                        customParameters    = {
                            loginUri        = {
                                value       = var.microsoft_login_uri
                            },
                            tenantId        = {
                                value       = var.tenant_id
                            },
                            resourceUri     = {
                                value       = var.graph_resource_uri
                            },
                            enableOnbehalfOfLogin = {
                                value       = "false"
                            }
                        }
                    }
                }
            },
            capabilities    = [],
            description     = var.connector_description,
            displayName     = "Microsoft Universal Print Custom Connector",
            iconUri         = "https://content.powerapps.com/resource/makerx/static/media/default-connection-icon.74fb37fa.svg",
            apiType         = "Rest",
            swagger         = {
                "swagger": "2.0",
                "info": {
                    "title": "Microsoft Graph Rest APIs for Universal Print",
                    "description": "Microsoft Graph Rest APIs for Universal Print",
                    "version": "v1.0"
                },
                "host": "graph.microsoft.com",
                "basePath": "/",
                "schemes": [
                    "https"
                ],
                "consumes": [],
                "produces": [],
                "paths": {
                    "/v1.0/print/shares/{printerShareId}": {
                        "get": {
                            "responses": {
                                "200": {
                                    "description": "default",
                                    "schema": {
                                        "type": "object",
                                        "properties": {
                                            "@odata.context": {
                                                "type": "string",
                                                "description": "@odata.context"
                                            },
                                            "id": {
                                                "type": "string",
                                                "description": "id"
                                            },
                                            "displayName": {
                                                "type": "string",
                                                "description": "displayName"
                                            },
                                            "createdDateTime": {
                                                "type": "string",
                                                "description": "createdDateTime"
                                            },
                                            "isAcceptingJobs": {
                                                "type": "boolean",
                                                "description": "isAcceptingJobs"
                                            },
                                            "allowAllUsers": {
                                                "type": "boolean",
                                                "description": "allowAllUsers"
                                            },
                                            "status": {
                                                "type": "object",
                                                "properties": {
                                                    "state": {
                                                        "type": "string",
                                                        "description": "state"
                                                    },
                                                    "details": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "string"
                                                        },
                                                        "description": "details"
                                                    },
                                                    "description": {
                                                        "type": "string",
                                                        "description": "description"
                                                    }
                                                },
                                                "description": "status"
                                            },
                                            "defaults": {
                                                "type": "object",
                                                "properties": {
                                                    "copiesPerJob": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "copiesPerJob"
                                                    },
                                                    "finishings": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "string"
                                                        },
                                                        "description": "finishings"
                                                    },
                                                    "mediaColor": {
                                                        "type": "string",
                                                        "description": "mediaColor"
                                                    },
                                                    "mediaType": {
                                                        "type": "string",
                                                        "description": "mediaType"
                                                    },
                                                    "mediaSize": {
                                                        "type": "string",
                                                        "description": "mediaSize"
                                                    },
                                                    "pagesPerSheet": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "pagesPerSheet"
                                                    },
                                                    "orientation": {
                                                        "type": "string",
                                                        "description": "orientation"
                                                    },
                                                    "outputBin": {
                                                        "type": "string",
                                                        "description": "outputBin"
                                                    },
                                                    "inputBin": {
                                                        "type": "string",
                                                        "description": "inputBin"
                                                    },
                                                    "contentType": {
                                                        "type": "string",
                                                        "description": "contentType"
                                                    },
                                                    "fitPdfToPage": {
                                                        "type": "boolean",
                                                        "description": "fitPdfToPage"
                                                    },
                                                    "multipageLayout": {
                                                        "type": "string",
                                                        "description": "multipageLayout"
                                                    },
                                                    "colorMode": {
                                                        "type": "string",
                                                        "description": "colorMode"
                                                    },
                                                    "quality": {
                                                        "type": "string",
                                                        "description": "quality"
                                                    },
                                                    "duplexMode": {
                                                        "type": "string",
                                                        "description": "duplexMode"
                                                    },
                                                    "dpi": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "dpi"
                                                    },
                                                    "scaling": {
                                                        "type": "string",
                                                        "description": "scaling"
                                                    }
                                                },
                                                "description": "defaults"
                                            },
                                            "location": {
                                                "type": "object",
                                                "properties": {
                                                    "latitude": {
                                                        "type": "number",
                                                        "format": "float",
                                                        "description": "latitude"
                                                    },
                                                    "longitude": {
                                                        "type": "number",
                                                        "format": "float",
                                                        "description": "longitude"
                                                    },
                                                    "altitudeInMeters": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "altitudeInMeters"
                                                    },
                                                    "streetAddress": {
                                                        "type": "string",
                                                        "description": "streetAddress"
                                                    },
                                                    "subUnit": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "string"
                                                        },
                                                        "description": "subUnit"
                                                    },
                                                    "city": {
                                                        "type": "string",
                                                        "description": "city"
                                                    },
                                                    "postalCode": {
                                                        "type": "string",
                                                        "description": "postalCode"
                                                    },
                                                    "countryOrRegion": {
                                                        "type": "string",
                                                        "description": "countryOrRegion"
                                                    },
                                                    "site": {
                                                        "type": "string",
                                                        "description": "site"
                                                    },
                                                    "building": {
                                                        "type": "string",
                                                        "description": "building"
                                                    },
                                                    "floor": {
                                                        "type": "string",
                                                        "description": "floor"
                                                    },
                                                    "floorDescription": {
                                                        "type": "string",
                                                        "description": "floorDescription"
                                                    },
                                                    "roomName": {
                                                        "type": "string",
                                                        "description": "roomName"
                                                    },
                                                    "roomDescription": {
                                                        "type": "string",
                                                        "description": "roomDescription"
                                                    },
                                                    "organization": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "string"
                                                        },
                                                        "description": "organization"
                                                    },
                                                    "subdivision": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "string"
                                                        },
                                                        "description": "subdivision"
                                                    },
                                                    "stateOrProvince": {
                                                        "type": "string",
                                                        "description": "stateOrProvince"
                                                    }
                                                },
                                                "description": "location"
                                            }
                                        }
                                    },
                                    "headers": {
                                        "Content-type": {
                                            "description": "Content-type",
                                            "type": "string"
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
                            },
                            "summary": "Get printer share by id",
                            "description": "Get printer share by id",
                            "operationId": "PrinterShares_GetPrinterShare",
                            "x-ms-visibility": "important",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "name": "Content-type",
                                    "in": "header",
                                    "required": false,
                                    "type": "string"
                                }
                            ]
                        }
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs": {
                        "post": {
                            "responses": {
                                "201": {
                                    "description": "default",
                                    "schema": {
                                        "type": "object",
                                        "properties": {
                                            "@odata.context": {
                                                "type": "string",
                                                "description": "@odata.context"
                                            },
                                            "id": {
                                                "type": "string",
                                                "description": "id"
                                            },
                                            "createdDateTime": {
                                                "type": "string",
                                                "description": "createdDateTime"
                                            },
                                            "isFetchable": {
                                                "type": "boolean",
                                                "description": "isFetchable"
                                            },
                                            "redirectedFrom": {
                                                "type": "string",
                                                "description": "redirectedFrom"
                                            },
                                            "redirectedTo": {
                                                "type": "string",
                                                "description": "redirectedTo"
                                            },
                                            "createdBy": {
                                                "type": "object",
                                                "properties": {
                                                    "id": {
                                                        "type": "string",
                                                        "description": "id"
                                                    },
                                                    "displayName": {
                                                        "type": "string",
                                                        "description": "displayName"
                                                    },
                                                    "ipAddress": {
                                                        "type": "string",
                                                        "description": "ipAddress"
                                                    },
                                                    "userPrincipalName": {
                                                        "type": "string",
                                                        "description": "userPrincipalName"
                                                    }
                                                },
                                                "description": "createdBy"
                                            },
                                            "status": {
                                                "type": "object",
                                                "properties": {
                                                    "state": {
                                                        "type": "string",
                                                        "description": "state"
                                                    },
                                                    "description": {
                                                        "type": "string",
                                                        "description": "description"
                                                    },
                                                    "isAcquiredByPrinter": {
                                                        "type": "boolean",
                                                        "description": "isAcquiredByPrinter"
                                                    },
                                                    "details": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "string"
                                                        },
                                                        "description": "details"
                                                    }
                                                },
                                                "description": "status"
                                            },
                                            "configuration": {
                                                "type": "object",
                                                "properties": {
                                                    "quality": {
                                                        "type": "string",
                                                        "description": "quality"
                                                    },
                                                    "dpi": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "dpi"
                                                    },
                                                    "feedOrientation": {
                                                        "type": "string",
                                                        "description": "feedOrientation"
                                                    },
                                                    "orientation": {
                                                        "type": "string",
                                                        "description": "orientation"
                                                    },
                                                    "duplexMode": {
                                                        "type": "string",
                                                        "description": "duplexMode"
                                                    },
                                                    "copies": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "copies"
                                                    },
                                                    "colorMode": {
                                                        "type": "string",
                                                        "description": "colorMode"
                                                    },
                                                    "inputBin": {
                                                        "type": "string",
                                                        "description": "inputBin"
                                                    },
                                                    "outputBin": {
                                                        "type": "string",
                                                        "description": "outputBin"
                                                    },
                                                    "mediaSize": {
                                                        "type": "string",
                                                        "description": "mediaSize"
                                                    },
                                                    "mediaType": {
                                                        "type": "string",
                                                        "description": "mediaType"
                                                    },
                                                    "finishings": {
                                                        "type": "string",
                                                        "description": "finishings"
                                                    },
                                                    "pagesPerSheet": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "pagesPerSheet"
                                                    },
                                                    "multipageLayout": {
                                                        "type": "string",
                                                        "description": "multipageLayout"
                                                    },
                                                    "collate": {
                                                        "type": "boolean",
                                                        "description": "collate"
                                                    },
                                                    "scaling": {
                                                        "type": "string",
                                                        "description": "scaling"
                                                    },
                                                    "fitPdfToPage": {
                                                        "type": "boolean",
                                                        "description": "fitPdfToPage"
                                                    },
                                                    "pageRanges": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "object",
                                                            "properties": {
                                                                "start": {
                                                                    "type": "integer",
                                                                    "format": "int32",
                                                                    "description": "start"
                                                                },
                                                                "end": {
                                                                    "type": "integer",
                                                                    "format": "int32",
                                                                    "description": "end"
                                                                }
                                                            }
                                                        },
                                                        "description": "pageRanges"
                                                    },
                                                    "margin": {
                                                        "type": "object",
                                                        "properties": {
                                                            "top": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "top"
                                                            },
                                                            "bottom": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "bottom"
                                                            },
                                                            "left": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "left"
                                                            },
                                                            "right": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "right"
                                                            }
                                                        },
                                                        "description": "margin"
                                                    }
                                                },
                                                "description": "configuration"
                                            },
                                            "documents": {
                                                "type": "array",
                                                "items": {
                                                    "type": "object",
                                                    "properties": {
                                                        "id": {
                                                            "type": "string",
                                                            "description": "id"
                                                        },
                                                        "displayName": {
                                                            "type": "string",
                                                            "description": "displayName"
                                                        },
                                                        "contentType": {
                                                            "type": "string",
                                                            "description": "contentType"
                                                        },
                                                        "size": {
                                                            "type": "integer",
                                                            "format": "int32",
                                                            "description": "size"
                                                        }
                                                    }
                                                },
                                                "description": "documents"
                                            }
                                        }
                                    },
                                    "headers": {
                                        "Content-Type": {
                                            "description": "Content-Type",
                                            "type": "string"
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
                            },
                            "summary": "Create printJob for a printerShare",
                            "description": "Create printJob for a printerShare",
                            "operationId": "PrinterShares_PostToJobsFromPrinterShare",
                            "x-ms-visibility": "important",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "name": "Content-Type",
                                    "in": "header",
                                    "required": false,
                                    "type": "string"
                                },
                                {
                                    "name": "body",
                                    "in": "body",
                                    "required": false,
                                    "schema": {
                                        "type": "object",
                                        "properties": {
                                            "configuration": {
                                                "type": "object",
                                                "properties": {
                                                    "feedOrientation": {
                                                        "type": "string",
                                                        "description": "feedOrientation"
                                                    },
                                                    "pageRanges": {
                                                        "type": "array",
                                                        "items": {
                                                            "type": "object",
                                                            "properties": {
                                                                "start": {
                                                                    "type": "integer",
                                                                    "format": "int32",
                                                                    "description": "start"
                                                                },
                                                                "end": {
                                                                    "type": "integer",
                                                                    "format": "int32",
                                                                    "description": "end"
                                                                }
                                                            }
                                                        },
                                                        "description": "pageRanges"
                                                    },
                                                    "quality": {
                                                        "type": "string",
                                                        "description": "quality"
                                                    },
                                                    "dpi": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "dpi"
                                                    },
                                                    "orientation": {
                                                        "type": "string",
                                                        "description": "orientation"
                                                    },
                                                    "copies": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "copies"
                                                    },
                                                    "duplexMode": {
                                                        "type": "string",
                                                        "description": "duplexMode"
                                                    },
                                                    "colorMode": {
                                                        "type": "string",
                                                        "description": "colorMode"
                                                    },
                                                    "inputBin": {
                                                        "type": "string",
                                                        "description": "inputBin"
                                                    },
                                                    "outputBin": {
                                                        "type": "string",
                                                        "description": "outputBin"
                                                    },
                                                    "mediaSize": {
                                                        "type": "string",
                                                        "description": "mediaSize"
                                                    },
                                                    "margin": {
                                                        "type": "object",
                                                        "properties": {
                                                            "top": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "top"
                                                            },
                                                            "bottom": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "bottom"
                                                            },
                                                            "left": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "left"
                                                            },
                                                            "right": {
                                                                "type": "integer",
                                                                "format": "int32",
                                                                "description": "right"
                                                            }
                                                        },
                                                        "description": "margin"
                                                    },
                                                    "mediaType": {
                                                        "type": "string",
                                                        "description": "mediaType"
                                                    },
                                                    "finishings": {
                                                        "type": "string",
                                                        "description": "finishings"
                                                    },
                                                    "pagesPerSheet": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "pagesPerSheet"
                                                    },
                                                    "multipageLayout": {
                                                        "type": "string",
                                                        "description": "multipageLayout"
                                                    },
                                                    "collate": {
                                                        "type": "boolean",
                                                        "description": "collate"
                                                    },
                                                    "scaling": {
                                                        "type": "string",
                                                        "description": "scaling"
                                                    },
                                                    "fitPdfToPage": {
                                                        "type": "boolean",
                                                        "description": "fitPdfToPage"
                                                    }
                                                },
                                                "description": "configuration"
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs/{jobId}/start": {
                        "post": {
                            "responses": {
                                "200": {
                                    "description": "default",
                                    "schema": {
                                        "type": "object",
                                        "properties": {
                                            "state": {
                                                "type": "string",
                                                "description": "state"
                                            },
                                            "description": {
                                                "type": "string",
                                                "description": "description"
                                            },
                                            "isAcquiredByPrinter": {
                                                "type": "boolean",
                                                "description": "isAcquiredByPrinter"
                                            },
                                            "details": {
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "description": "details"
                                            }
                                        }
                                    },
                                    "headers": {
                                        "Content-type": {
                                            "description": "Content-type",
                                            "type": "string"
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
                            },
                            "summary": "Start printer job",
                            "description": "Start printer job",
                            "operationId": "PrinterShares_StartPrintJob",
                            "x-ms-visibility": "important",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "name": "jobId",
                                    "in": "path",
                                    "required": true,
                                    "type": "string"
                                }
                            ]
                        }
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs/{jobId}/documents/{documentId}/createUploadSession": {
                        "post": {
                            "responses": {
                                "200": {
                                    "description": "default",
                                    "schema": {
                                        "type": "object",
                                        "properties": {
                                            "@odata.context": {
                                                "type": "string",
                                                "description": "@odata.context"
                                            },
                                            "uploadUrl": {
                                                "type": "string",
                                                "description": "uploadUrl"
                                            },
                                            "expirationDateTime": {
                                                "type": "string",
                                                "description": "expirationDateTime"
                                            },
                                            "nextExpectedRanges": {
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "description": "nextExpectedRanges"
                                            }
                                        }
                                    },
                                    "headers": {
                                        "Content-type": {
                                            "description": "Content-type",
                                            "type": "string"
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
                            },
                            "summary": "Create upload session for printer share",
                            "description": "Create upload session for printer share",
                            "operationId": "PrinterShares_CreateUploadSession",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "name": "jobId",
                                    "in": "path",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "name": "documentId",
                                    "in": "path",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "name": "Content-type",
                                    "in": "header",
                                    "required": false,
                                    "type": "string"
                                },
                                {
                                    "name": "body",
                                    "in": "body",
                                    "required": false,
                                    "schema": {
                                        "type": "object",
                                        "properties": {
                                            "properties": {
                                                "type": "object",
                                                "properties": {
                                                    "documentName": {
                                                        "type": "string",
                                                        "description": "documentName"
                                                    },
                                                    "contentType": {
                                                        "type": "string",
                                                        "description": "contentType"
                                                    },
                                                    "size": {
                                                        "type": "integer",
                                                        "format": "int32",
                                                        "description": "size"
                                                    }
                                                },
                                                "description": "properties"
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                    }
                },
                "definitions": {
                    "microsoft.graph.PrinterShare": {
                        "type": "object",
                        "properties": {
                            "viewPoint": {
                                "type": "object",
                                "properties": {
                                    "lastUsedDateTime": {
                                        "description": "lastUsedDateTime",
                                        "type": "string"
                                    }
                                }
                            },
                            "allowAllUsers": {
                                "description": "allowAllUsers",
                                "type": "boolean"
                            },
                            "createdDateTime": {
                                "description": "createdDateTime",
                                "type": "string"
                            },
                            "id": {
                                "description": "id",
                                "type": "string"
                            },
                            "name": {
                                "description": "name",
                                "type": "string"
                            },
                            "displayName": {
                                "description": "displayName",
                                "type": "string"
                            },
                            "manufacturer": {
                                "description": "manufacturer",
                                "type": "string"
                            },
                            "model": {
                                "description": "model",
                                "type": "string"
                            },
                            "status": {
                                "type": "object",
                                "properties": {
                                    "processingState": {
                                        "description": "processingState",
                                        "type": "string"
                                    },
                                    "state": {
                                        "description": "state",
                                        "type": "string"
                                    },
                                    "processingStateReasons": {
                                        "description": "processingStateReasons",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "details": {
                                        "description": "details",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "processingStateDescription": {
                                        "description": "processingStateDescription",
                                        "type": "string"
                                    },
                                    "description": {
                                        "description": "description",
                                        "type": "string"
                                    }
                                }
                            },
                            "location": {
                                "type": "object",
                                "properties": {
                                    "latitude": {
                                        "description": "latitude",
                                        "type": "number"
                                    },
                                    "longitude": {
                                        "description": "longitude",
                                        "type": "number"
                                    },
                                    "altitudeInMeters": {
                                        "description": "altitudeInMeters",
                                        "type": "integer"
                                    },
                                    "streetAddress": {
                                        "description": "streetAddress",
                                        "type": "string"
                                    },
                                    "subunit": {
                                        "description": "subunit",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "city": {
                                        "description": "city",
                                        "type": "string"
                                    },
                                    "region": {
                                        "description": "region",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "postalCode": {
                                        "description": "postalCode",
                                        "type": "string"
                                    },
                                    "country": {
                                        "description": "country",
                                        "type": "string"
                                    },
                                    "site": {
                                        "description": "site",
                                        "type": "string"
                                    },
                                    "building": {
                                        "description": "building",
                                        "type": "string"
                                    },
                                    "floorNumber": {
                                        "description": "floorNumber",
                                        "type": "integer"
                                    },
                                    "floor": {
                                        "description": "floor",
                                        "type": "string"
                                    },
                                    "floorDescription": {
                                        "description": "floorDescription",
                                        "type": "string"
                                    },
                                    "roomNumber": {
                                        "description": "roomNumber",
                                        "type": "integer"
                                    },
                                    "roomName": {
                                        "description": "roomName",
                                        "type": "string"
                                    },
                                    "roomDescription": {
                                        "description": "roomDescription",
                                        "type": "string"
                                    },
                                    "organization": {
                                        "description": "organization",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "subdivision": {
                                        "description": "subdivision",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "stateOrProvince": {
                                        "description": "stateOrProvince",
                                        "type": "string"
                                    },
                                    "countryOrRegion": {
                                        "description": "countryOrRegion",
                                        "type": "string"
                                    }
                                }
                            },
                            "isAcceptingJobs": {
                                "description": "isAcceptingJobs",
                                "type": "boolean"
                            },
                            "defaults": {
                                "type": "object",
                                "properties": {
                                    "copiesPerJob": {
                                        "description": "copiesPerJob",
                                        "type": "integer"
                                    },
                                    "finishings": {
                                        "description": "finishings",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "mediaColor": {
                                        "description": "mediaColor",
                                        "type": "string"
                                    },
                                    "mediaType": {
                                        "description": "mediaType",
                                        "type": "string"
                                    },
                                    "mediaSize": {
                                        "description": "mediaSize",
                                        "type": "string"
                                    },
                                    "pagesPerSheet": {
                                        "description": "pagesPerSheet",
                                        "type": "integer"
                                    },
                                    "orientation": {
                                        "description": "orientation",
                                        "type": "string"
                                    },
                                    "outputBin": {
                                        "description": "outputBin",
                                        "type": "string"
                                    },
                                    "inputBin": {
                                        "description": "inputBin",
                                        "type": "string"
                                    },
                                    "documentMimeType": {
                                        "description": "documentMimeType",
                                        "type": "string"
                                    },
                                    "pdfFitToPage": {
                                        "description": "pdfFitToPage",
                                        "type": "boolean"
                                    },
                                    "duplexConfiguration": {
                                        "description": "duplexConfiguration",
                                        "type": "string"
                                    },
                                    "presentationDirection": {
                                        "description": "presentationDirection",
                                        "type": "string"
                                    },
                                    "printColorConfiguration": {
                                        "description": "printColorConfiguration",
                                        "type": "string"
                                    },
                                    "printQuality": {
                                        "description": "printQuality",
                                        "type": "string"
                                    },
                                    "contentType": {
                                        "description": "contentType",
                                        "type": "string"
                                    },
                                    "fitPdfToPage": {
                                        "description": "fitPdfToPage",
                                        "type": "boolean"
                                    },
                                    "multipageLayout": {
                                        "description": "multipageLayout",
                                        "type": "string"
                                    },
                                    "colorMode": {
                                        "description": "colorMode",
                                        "type": "string"
                                    },
                                    "quality": {
                                        "description": "quality",
                                        "type": "string"
                                    },
                                    "duplexMode": {
                                        "description": "duplexMode",
                                        "type": "string"
                                    },
                                    "dpi": {
                                        "description": "dpi",
                                        "type": "integer"
                                    },
                                    "scaling": {
                                        "description": "scaling",
                                        "type": "string"
                                    }
                                }
                            },
                            "capabilities": {
                                "type": "object",
                                "properties": {
                                    "isColorPrintingSupported": {
                                        "description": "isColorPrintingSupported",
                                        "type": "boolean"
                                    },
                                    "supportsFitPdfToPage": {
                                        "description": "supportsFitPdfToPage",
                                        "type": "boolean"
                                    },
                                    "supportedCopiesPerJob": {
                                        "type": "object",
                                        "properties": {
                                            "start": {
                                                "description": "start",
                                                "type": "integer"
                                            },
                                            "end": {
                                                "description": "end",
                                                "type": "integer"
                                            },
                                            "minimum": {
                                                "description": "minimum",
                                                "type": "integer"
                                            },
                                            "maximum": {
                                                "description": "maximum",
                                                "type": "integer"
                                            }
                                        }
                                    },
                                    "supportedDocumentMimeTypes": {
                                        "description": "supportedDocumentMimeTypes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedFinishings": {
                                        "description": "supportedFinishings",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedMediaColors": {
                                        "description": "supportedMediaColors",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedMediaTypes": {
                                        "description": "supportedMediaTypes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedMediaSizes": {
                                        "description": "supportedMediaSizes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedPagesPerSheet": {
                                        "type": "object",
                                        "properties": {
                                            "start": {
                                                "description": "start",
                                                "type": "integer"
                                            },
                                            "end": {
                                                "description": "end",
                                                "type": "integer"
                                            },
                                            "minimum": {
                                                "description": "minimum",
                                                "type": "integer"
                                            },
                                            "maximum": {
                                                "description": "maximum",
                                                "type": "integer"
                                            }
                                        }
                                    },
                                    "supportedOrientations": {
                                        "description": "supportedOrientations",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedOutputBins": {
                                        "description": "supportedOutputBins",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedDuplexConfigurations": {
                                        "description": "supportedDuplexConfigurations",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedPresentationDirections": {
                                        "description": "supportedPresentationDirections",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedColorConfigurations": {
                                        "description": "supportedColorConfigurations",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "supportedPrintQualities": {
                                        "description": "supportedPrintQualities",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "contentTypes": {
                                        "description": "contentTypes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "feedOrientations": {
                                        "description": "feedOrientations",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "feedDirections": {
                                        "description": "feedDirections",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "isPageRangeSupported": {
                                        "description": "isPageRangeSupported",
                                        "type": "boolean"
                                    },
                                    "qualities": {
                                        "description": "qualities",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "dpis": {
                                        "description": "dpis",
                                        "type": "array",
                                        "items": {
                                            "type": "integer"
                                        }
                                    },
                                    "duplexModes": {
                                        "description": "duplexModes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "copiesPerJob": {
                                        "type": "object",
                                        "properties": {
                                            "start": {
                                                "description": "start",
                                                "type": "integer"
                                            },
                                            "end": {
                                                "description": "end",
                                                "type": "integer"
                                            },
                                            "minimum": {
                                                "description": "minimum",
                                                "type": "integer"
                                            },
                                            "maximum": {
                                                "description": "maximum",
                                                "type": "integer"
                                            }
                                        }
                                    },
                                    "finishings": {
                                        "description": "finishings",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "mediaColors": {
                                        "description": "mediaColors",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "mediaTypes": {
                                        "description": "mediaTypes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "mediaSizes": {
                                        "description": "mediaSizes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "pagesPerSheet": {
                                        "description": "pagesPerSheet",
                                        "type": "array",
                                        "items": {
                                            "type": "integer"
                                        }
                                    },
                                    "orientations": {
                                        "description": "orientations",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "outputBins": {
                                        "description": "outputBins",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "multipageLayouts": {
                                        "description": "multipageLayouts",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "colorModes": {
                                        "description": "colorModes",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "inputBins": {
                                        "description": "inputBins",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "topMargins": {
                                        "description": "topMargins",
                                        "type": "array",
                                        "items": {
                                            "type": "integer"
                                        }
                                    },
                                    "bottomMargins": {
                                        "description": "bottomMargins",
                                        "type": "array",
                                        "items": {
                                            "type": "integer"
                                        }
                                    },
                                    "rightMargins": {
                                        "description": "rightMargins",
                                        "type": "array",
                                        "items": {
                                            "type": "integer"
                                        }
                                    },
                                    "leftMargins": {
                                        "description": "leftMargins",
                                        "type": "array",
                                        "items": {
                                            "type": "integer"
                                        }
                                    },
                                    "collation": {
                                        "description": "collation",
                                        "type": "boolean"
                                    },
                                    "scalings": {
                                        "description": "scalings",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "microsoft.graph.PrinterShareViewpoint": {
                        "type": "object",
                        "properties": {
                            "lastUsedDateTime": {
                                "description": "lastUsedDateTime",
                                "type": "string"
                            }
                        }
                    },
                    "microsoft.graph.printerStatus": {
                        "type": "object",
                        "properties": {
                            "processingState": {
                                "description": "processingState",
                                "type": "string"
                            },
                            "state": {
                                "description": "state",
                                "type": "string"
                            },
                            "processingStateReasons": {
                                "description": "processingStateReasons",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "details": {
                                "description": "details",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "processingStateDescription": {
                                "description": "processingStateDescription",
                                "type": "string"
                            },
                            "description": {
                                "description": "description",
                                "type": "string"
                            }
                        }
                    },
                    "microsoft.graph.printerLocation": {
                        "type": "object",
                        "properties": {
                            "latitude": {
                                "description": "latitude",
                                "type": "number"
                            },
                            "longitude": {
                                "description": "longitude",
                                "type": "number"
                            },
                            "altitudeInMeters": {
                                "description": "altitudeInMeters",
                                "type": "integer"
                            },
                            "streetAddress": {
                                "description": "streetAddress",
                                "type": "string"
                            },
                            "subunit": {
                                "description": "subunit",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "city": {
                                "description": "city",
                                "type": "string"
                            },
                            "region": {
                                "description": "region",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "postalCode": {
                                "description": "postalCode",
                                "type": "string"
                            },
                            "country": {
                                "description": "country",
                                "type": "string"
                            },
                            "site": {
                                "description": "site",
                                "type": "string"
                            },
                            "building": {
                                "description": "building",
                                "type": "string"
                            },
                            "floorNumber": {
                                "description": "floorNumber",
                                "type": "integer"
                            },
                            "floor": {
                                "description": "floor",
                                "type": "string"
                            },
                            "floorDescription": {
                                "description": "floorDescription",
                                "type": "string"
                            },
                            "roomNumber": {
                                "description": "roomNumber",
                                "type": "integer"
                            },
                            "roomName": {
                                "description": "roomName",
                                "type": "string"
                            },
                            "roomDescription": {
                                "description": "roomDescription",
                                "type": "string"
                            },
                            "organization": {
                                "description": "organization",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "subdivision": {
                                "description": "subdivision",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "stateOrProvince": {
                                "description": "stateOrProvince",
                                "type": "string"
                            },
                            "countryOrRegion": {
                                "description": "countryOrRegion",
                                "type": "string"
                            }
                        }
                    },
                    "microsoft.graph.printerDefaults": {
                        "type": "object",
                        "properties": {
                            "copiesPerJob": {
                                "description": "copiesPerJob",
                                "type": "integer"
                            },
                            "finishings": {
                                "description": "finishings",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "mediaColor": {
                                "description": "mediaColor",
                                "type": "string"
                            },
                            "mediaType": {
                                "description": "mediaType",
                                "type": "string"
                            },
                            "mediaSize": {
                                "description": "mediaSize",
                                "type": "string"
                            },
                            "pagesPerSheet": {
                                "description": "pagesPerSheet",
                                "type": "integer"
                            },
                            "orientation": {
                                "description": "orientation",
                                "type": "string"
                            },
                            "outputBin": {
                                "description": "outputBin",
                                "type": "string"
                            },
                            "inputBin": {
                                "description": "inputBin",
                                "type": "string"
                            },
                            "documentMimeType": {
                                "description": "documentMimeType",
                                "type": "string"
                            },
                            "pdfFitToPage": {
                                "description": "pdfFitToPage",
                                "type": "boolean"
                            },
                            "duplexConfiguration": {
                                "description": "duplexConfiguration",
                                "type": "string"
                            },
                            "presentationDirection": {
                                "description": "presentationDirection",
                                "type": "string"
                            },
                            "printColorConfiguration": {
                                "description": "printColorConfiguration",
                                "type": "string"
                            },
                            "printQuality": {
                                "description": "printQuality",
                                "type": "string"
                            },
                            "contentType": {
                                "description": "contentType",
                                "type": "string"
                            },
                            "fitPdfToPage": {
                                "description": "fitPdfToPage",
                                "type": "boolean"
                            },
                            "multipageLayout": {
                                "description": "multipageLayout",
                                "type": "string"
                            },
                            "colorMode": {
                                "description": "colorMode",
                                "type": "string"
                            },
                            "quality": {
                                "description": "quality",
                                "type": "string"
                            },
                            "duplexMode": {
                                "description": "duplexMode",
                                "type": "string"
                            },
                            "dpi": {
                                "description": "dpi",
                                "type": "integer"
                            },
                            "scaling": {
                                "description": "scaling",
                                "type": "string"
                            }
                        }
                    },
                    "microsoft.graph.printerCapabilities": {
                        "type": "object",
                        "properties": {
                            "isColorPrintingSupported": {
                                "description": "isColorPrintingSupported",
                                "type": "boolean"
                            },
                            "supportsFitPdfToPage": {
                                "description": "supportsFitPdfToPage",
                                "type": "boolean"
                            },
                            "supportedCopiesPerJob": {
                                "type": "object",
                                "properties": {
                                    "start": {
                                        "description": "start",
                                        "type": "integer"
                                    },
                                    "end": {
                                        "description": "end",
                                        "type": "integer"
                                    },
                                    "minimum": {
                                        "description": "minimum",
                                        "type": "integer"
                                    },
                                    "maximum": {
                                        "description": "maximum",
                                        "type": "integer"
                                    }
                                }
                            },
                            "supportedDocumentMimeTypes": {
                                "description": "supportedDocumentMimeTypes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedFinishings": {
                                "description": "supportedFinishings",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedMediaColors": {
                                "description": "supportedMediaColors",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedMediaTypes": {
                                "description": "supportedMediaTypes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedMediaSizes": {
                                "description": "supportedMediaSizes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedPagesPerSheet": {
                                "type": "object",
                                "properties": {
                                    "start": {
                                        "description": "start",
                                        "type": "integer"
                                    },
                                    "end": {
                                        "description": "end",
                                        "type": "integer"
                                    },
                                    "minimum": {
                                        "description": "minimum",
                                        "type": "integer"
                                    },
                                    "maximum": {
                                        "description": "maximum",
                                        "type": "integer"
                                    }
                                }
                            },
                            "supportedOrientations": {
                                "description": "supportedOrientations",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedOutputBins": {
                                "description": "supportedOutputBins",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedDuplexConfigurations": {
                                "description": "supportedDuplexConfigurations",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedPresentationDirections": {
                                "description": "supportedPresentationDirections",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedColorConfigurations": {
                                "description": "supportedColorConfigurations",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "supportedPrintQualities": {
                                "description": "supportedPrintQualities",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "contentTypes": {
                                "description": "contentTypes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "feedOrientations": {
                                "description": "feedOrientations",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "feedDirections": {
                                "description": "feedDirections",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "isPageRangeSupported": {
                                "description": "isPageRangeSupported",
                                "type": "boolean"
                            },
                            "qualities": {
                                "description": "qualities",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "dpis": {
                                "description": "dpis",
                                "type": "array",
                                "items": {
                                    "type": "integer"
                                }
                            },
                            "duplexModes": {
                                "description": "duplexModes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "copiesPerJob": {
                                "type": "object",
                                "properties": {
                                    "start": {
                                        "description": "start",
                                        "type": "integer"
                                    },
                                    "end": {
                                        "description": "end",
                                        "type": "integer"
                                    },
                                    "minimum": {
                                        "description": "minimum",
                                        "type": "integer"
                                    },
                                    "maximum": {
                                        "description": "maximum",
                                        "type": "integer"
                                    }
                                }
                            },
                            "finishings": {
                                "description": "finishings",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "mediaColors": {
                                "description": "mediaColors",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "mediaTypes": {
                                "description": "mediaTypes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "mediaSizes": {
                                "description": "mediaSizes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "pagesPerSheet": {
                                "description": "pagesPerSheet",
                                "type": "array",
                                "items": {
                                    "type": "integer"
                                }
                            },
                            "orientations": {
                                "description": "orientations",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "outputBins": {
                                "description": "outputBins",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "multipageLayouts": {
                                "description": "multipageLayouts",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "colorModes": {
                                "description": "colorModes",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "inputBins": {
                                "description": "inputBins",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "topMargins": {
                                "description": "topMargins",
                                "type": "array",
                                "items": {
                                    "type": "integer"
                                }
                            },
                            "bottomMargins": {
                                "description": "bottomMargins",
                                "type": "array",
                                "items": {
                                    "type": "integer"
                                }
                            },
                            "rightMargins": {
                                "description": "rightMargins",
                                "type": "array",
                                "items": {
                                    "type": "integer"
                                }
                            },
                            "leftMargins": {
                                "description": "leftMargins",
                                "type": "array",
                                "items": {
                                    "type": "integer"
                                }
                            },
                            "collation": {
                                "description": "collation",
                                "type": "boolean"
                            },
                            "scalings": {
                                "description": "scalings",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            }
                        }
                    },
                    "microsoft.graph.printJob": {
                        "type": "object",
                        "properties": {
                            "id": {
                                "description": "id",
                                "type": "string"
                            },
                            "createdBy": {
                                "type": "object",
                                "properties": {
                                    "id": {
                                        "description": "id",
                                        "type": "string"
                                    },
                                    "displayName": {
                                        "description": "displayName",
                                        "type": "string"
                                    },
                                    "ipAddress": {
                                        "description": "ipAddress",
                                        "type": "string"
                                    },
                                    "userPrincipalName": {
                                        "description": "userPrincipalName",
                                        "type": "string"
                                    },
                                    "oDataType": {
                                        "description": "oDataType",
                                        "type": "string"
                                    }
                                }
                            },
                            "createdDateTime": {
                                "description": "createdDateTime",
                                "type": "string"
                            },
                            "isFetchable": {
                                "description": "isFetchable",
                                "type": "boolean"
                            },
                            "status": {
                                "type": "object",
                                "properties": {
                                    "processingState": {
                                        "description": "processingState",
                                        "type": "string"
                                    },
                                    "state": {
                                        "description": "state",
                                        "type": "string"
                                    },
                                    "processingStateDescription": {
                                        "description": "processingStateDescription",
                                        "type": "string"
                                    },
                                    "description": {
                                        "description": "description",
                                        "type": "string"
                                    },
                                    "wasJobAcquiredByPrinter": {
                                        "description": "wasJobAcquiredByPrinter",
                                        "type": "boolean"
                                    },
                                    "isAcquiredByPrinter": {
                                        "description": "isAcquiredByPrinter",
                                        "type": "boolean"
                                    },
                                    "details": {
                                        "description": "details",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    }
                                }
                            },
                            "redirectedFrom": {
                                "description": "redirectedFrom",
                                "type": "string"
                            },
                            "redirectedTo": {
                                "description": "redirectedTo",
                                "type": "string"
                            },
                            "configuration": {
                                "type": "object",
                                "properties": {
                                    "pageRanges": {
                                        "description": "pageRanges",
                                        "type": "array",
                                        "items": {
                                            "type": "object",
                                            "properties": {
                                                "start": {
                                                    "description": "start",
                                                    "type": "integer"
                                                },
                                                "end": {
                                                    "description": "end",
                                                    "type": "integer"
                                                },
                                                "minimum": {
                                                    "description": "minimum",
                                                    "type": "integer"
                                                },
                                                "maximum": {
                                                    "description": "maximum",
                                                    "type": "integer"
                                                }
                                            }
                                        }
                                    },
                                    "quality": {
                                        "description": "quality",
                                        "type": "string"
                                    },
                                    "dpi": {
                                        "description": "dpi",
                                        "type": "integer"
                                    },
                                    "feedOrientation": {
                                        "description": "feedOrientation",
                                        "type": "string"
                                    },
                                    "orientation": {
                                        "description": "orientation",
                                        "type": "string"
                                    },
                                    "duplexMode": {
                                        "description": "duplexMode",
                                        "type": "string"
                                    },
                                    "copies": {
                                        "description": "copies",
                                        "type": "integer"
                                    },
                                    "colorMode": {
                                        "description": "colorMode",
                                        "type": "string"
                                    },
                                    "inputBin": {
                                        "description": "inputBin",
                                        "type": "string"
                                    },
                                    "outputBin": {
                                        "description": "outputBin",
                                        "type": "string"
                                    },
                                    "mediaSize": {
                                        "description": "mediaSize",
                                        "type": "string"
                                    },
                                    "margin": {
                                        "type": "object",
                                        "properties": {
                                            "top": {
                                                "description": "top",
                                                "type": "integer"
                                            },
                                            "bottom": {
                                                "description": "bottom",
                                                "type": "integer"
                                            },
                                            "left": {
                                                "description": "left",
                                                "type": "integer"
                                            },
                                            "right": {
                                                "description": "right",
                                                "type": "integer"
                                            }
                                        }
                                    },
                                    "mediaType": {
                                        "description": "mediaType",
                                        "type": "string"
                                    },
                                    "finishings": {
                                        "description": "finishings",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                    },
                                    "pagesPerSheet": {
                                        "description": "pagesPerSheet",
                                        "type": "integer"
                                    },
                                    "multipageLayout": {
                                        "description": "multipageLayout",
                                        "type": "string"
                                    },
                                    "collate": {
                                        "description": "collate",
                                        "type": "boolean"
                                    },
                                    "scaling": {
                                        "description": "scaling",
                                        "type": "string"
                                    },
                                    "fitPdfToPage": {
                                        "description": "fitPdfToPage",
                                        "type": "boolean"
                                    }
                                }
                            },
                            "displayName": {
                                "description": "displayName",
                                "type": "string"
                            },
                            "errorCode": {
                                "description": "errorCode",
                                "type": "integer"
                            },
                            "acknowledgedDateTime": {
                                "description": "acknowledgedDateTime",
                                "type": "string"
                            },
                            "completedDateTime": {
                                "description": "completedDateTime",
                                "type": "string"
                            }
                        }
                    },
                    "microsoft.graph.printJobStatus": {
                        "type": "object",
                        "properties": {
                            "processingState": {
                                "description": "processingState",
                                "type": "string"
                            },
                            "state": {
                                "description": "state",
                                "type": "string"
                            },
                            "processingStateDescription": {
                                "description": "processingStateDescription",
                                "type": "string"
                            },
                            "description": {
                                "description": "description",
                                "type": "string"
                            },
                            "wasJobAcquiredByPrinter": {
                                "description": "wasJobAcquiredByPrinter",
                                "type": "boolean"
                            },
                            "isAcquiredByPrinter": {
                                "description": "isAcquiredByPrinter",
                                "type": "boolean"
                            },
                            "details": {
                                "description": "details",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            }
                        }
                    },
                    "microsoft.graph.PrintDocumentUploadProperties": {
                        "type": "object",
                        "properties": {
                            "contentType": {
                                "description": "contentType",
                                "type": "string"
                            },
                            "documentName": {
                                "description": "documentName",
                                "type": "string"
                            },
                            "size": {
                                "description": "size",
                                "type": "integer"
                            }
                        }
                    },
                    "microsoft.graph.UploadSession": {
                        "type": "object",
                        "properties": {
                            "expirationDateTime": {
                                "description": "expirationDateTime",
                                "type": "string"
                            },
                            "nextExpectedRanges": {
                                "description": "nextExpectedRanges",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "uploadUrl": {
                                "description": "uploadUrl",
                                "type": "string"
                            },
                            "oDataType": {
                                "description": "oDataType",
                                "type": "string"
                            }
                        }
                    },
                    "microsoft.graph.printJobConfiguration": {
                        "type": "object",
                        "properties": {
                            "pageRanges": {
                                "description": "pageRanges",
                                "type": "array",
                                "items": {
                                    "type": "object",
                                    "properties": {
                                        "start": {
                                            "description": "start",
                                            "type": "integer"
                                        },
                                        "end": {
                                            "description": "end",
                                            "type": "integer"
                                        },
                                        "minimum": {
                                            "description": "minimum",
                                            "type": "integer"
                                        },
                                        "maximum": {
                                            "description": "maximum",
                                            "type": "integer"
                                        }
                                    }
                                }
                            },
                            "quality": {
                                "description": "quality",
                                "type": "string"
                            },
                            "dpi": {
                                "description": "dpi",
                                "type": "integer"
                            },
                            "feedOrientation": {
                                "description": "feedOrientation",
                                "type": "string"
                            },
                            "orientation": {
                                "description": "orientation",
                                "type": "string"
                            },
                            "duplexMode": {
                                "description": "duplexMode",
                                "type": "string"
                            },
                            "copies": {
                                "description": "copies",
                                "type": "integer"
                            },
                            "colorMode": {
                                "description": "colorMode",
                                "type": "string"
                            },
                            "inputBin": {
                                "description": "inputBin",
                                "type": "string"
                            },
                            "outputBin": {
                                "description": "outputBin",
                                "type": "string"
                            },
                            "mediaSize": {
                                "description": "mediaSize",
                                "type": "string"
                            },
                            "margin": {
                                "type": "object",
                                "properties": {
                                    "top": {
                                        "description": "top",
                                        "type": "integer"
                                    },
                                    "bottom": {
                                        "description": "bottom",
                                        "type": "integer"
                                    },
                                    "left": {
                                        "description": "left",
                                        "type": "integer"
                                    },
                                    "right": {
                                        "description": "right",
                                        "type": "integer"
                                    }
                                }
                            },
                            "mediaType": {
                                "description": "mediaType",
                                "type": "string"
                            },
                            "finishings": {
                                "description": "finishings",
                                "type": "array",
                                "items": {
                                    "type": "string"
                                }
                            },
                            "pagesPerSheet": {
                                "description": "pagesPerSheet",
                                "type": "integer"
                            },
                            "multipageLayout": {
                                "description": "multipageLayout",
                                "type": "string"
                            },
                            "collate": {
                                "description": "collate",
                                "type": "boolean"
                            },
                            "scaling": {
                                "description": "scaling",
                                "type": "string"
                            },
                            "fitPdfToPage": {
                                "description": "fitPdfToPage",
                                "type": "boolean"
                            }
                        }
                    },
                    "microsoft.graph.integerRange": {
                        "type": "object",
                        "properties": {
                            "start": {
                                "description": "start",
                                "type": "integer"
                            },
                            "end": {
                                "description": "end",
                                "type": "integer"
                            },
                            "minimum": {
                                "description": "minimum",
                                "type": "integer"
                            },
                            "maximum": {
                                "description": "maximum",
                                "type": "integer"
                            }
                        }
                    },
                    "microsoft.graph.printMargin": {
                        "type": "object",
                        "properties": {
                            "top": {
                                "description": "top",
                                "type": "integer"
                            },
                            "bottom": {
                                "description": "bottom",
                                "type": "integer"
                            },
                            "left": {
                                "description": "left",
                                "type": "integer"
                            },
                            "right": {
                                "description": "right",
                                "type": "integer"
                            }
                        }
                    },
                    "microsoft.graph.UserIdentity": {
                        "type": "object",
                        "properties": {
                            "id": {
                                "description": "id",
                                "type": "string"
                            },
                            "displayName": {
                                "description": "displayName",
                                "type": "string"
                            },
                            "ipAddress": {
                                "description": "ipAddress",
                                "type": "string"
                            },
                            "userPrincipalName": {
                                "description": "userPrincipalName",
                                "type": "string"
                            },
                            "oDataType": {
                                "description": "oDataType",
                                "type": "string"
                            }
                        }
                    }
                },
                "securityDefinitions": {
                    "oauth2-auth": {
                        "type": "oauth2",
                        "flow": "accessCode",
                        "tokenUrl": "https://login.windows.net/common/oauth2/authorize",
                        "scopes": {},
                        "authorizationUrl": "https://login.microsoftonline.com/common/oauth2/authorize"
                    }
                },
                "security": [
                    {
                        "oauth2-auth": []
                    }
                ],
                "parameters": {},
                "responses": {},
                "tags": []
            }
        }
    })
}

resource "azurerm_resource_group_template_deployment" "apiconnection" {
    name                = format("%s%s", "upgraph-connection", lower(random_string.random.result))
    resource_group_name = azurerm_resource_group.rg.name
    template_content    = data.local_file.apiconnection.content
    parameters_content  = jsonencode({
        "api_connection_name" = {
            value       = format("%s%s", "upgraph-connection", lower(random_string.random.result))
        },
        "custom_api_resourceid" = {
            value       = azapi_resource.custom_connector.id
        },
        "location"      = {
            value       = var.location
        }
    })
    deployment_mode = "Incremental"
}
