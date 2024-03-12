# Logic app custom connector
resource "azapi_resource" "symbolicname" {
    type                = "Microsoft.Web/customApis@2016-06-01"
    name                = format("%s-%s", lower(random_string.random.result), lower(var.location))
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
                        clientId            = var.client_id,
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
                            },
                            client_secret = {
                                value       = var.client_secret
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
                            "summary": "Get printer share by id",
                            "description": "Get printer share by id",
                            "operationId": "PrinterShares_GetPrinterShare",
                            "produces": [
                                "application/json"
                            ],
                            "parameters": [
                                {
                                    "in": "path",
                                    "name": "printerShareId",
                                    "description": "printer share Id",
                                    "required": true,
                                    "type": "string"
                                }
                            ],
                            "responses": {
                                "200": {
                                    "description": "Get printer share by id",
                                    "schema": {
                                        "type": "array",
                                        "items": {
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
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs": {
                        "post": {
                            "summary": "Create printer job from printer share",
                            "description": "Create printer job from printer share",
                            "operationId": "PrinterShares_PostToJobsFromPrinterShare",
                            "consumes": [
                                "application/json"
                            ],
                            "produces": [
                                "application/json"
                            ],
                            "parameters": [
                                {
                                    "in": "path",
                                    "name": "printerShareId",
                                    "description": "printer share Id",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "in": "body",
                                    "name": "body",
                                    "required": true,
                                    "schema": {
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
                                    }
                                }
                            ],
                            "responses": {
                                "200": {
                                    "description": "Create printer job from printer share",
                                    "schema": {
                                        "type": "array",
                                        "items": {
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
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs/{jobId}/start": {
                        "post": {
                            "summary": "Start printer job",
                            "description": "Start printer job",
                            "operationId": "PrinterShares_StartPrintJob",
                            "produces": [
                                "application/json"
                            ],
                            "parameters": [
                                {
                                    "in": "path",
                                    "name": "printerShareId",
                                    "description": "printer share Id",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "in": "path",
                                    "name": "jobId",
                                    "description": "job Id",
                                    "required": true,
                                    "type": "string"
                                }
                            ],
                            "responses": {
                                "200": {
                                    "description": "Start printer job",
                                    "schema": {
                                        "type": "array",
                                        "items": {
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
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs/{jobId}/documents/{documentId}/createUploadSession": {
                        "post": {
                            "summary": "Create upload session for printer share",
                            "description": "Create upload session for printer share",
                            "operationId": "PrinterShares_CreateUploadSession",
                            "consumes": [
                                "application/json"
                            ],
                            "produces": [
                                "application/json"
                            ],
                            "parameters": [
                                {
                                    "in": "path",
                                    "name": "printerShareId",
                                    "description": "printer share Id",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "in": "path",
                                    "name": "jobId",
                                    "description": "job Id",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "in": "path",
                                    "name": "documentId",
                                    "description": "document Id",
                                    "required": true,
                                    "type": "string"
                                },
                                {
                                    "in": "body",
                                    "name": "body",
                                    "required": true,
                                    "schema": {
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
                                    }
                                }
                            ],
                            "responses": {
                                "200": {
                                    "description": "Create upload session for printer share",
                                    "schema": {
                                        "type": "array",
                                        "items": {
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

resource "azuread_application_redirect_uris" "web_uris" {
    application_id      = var.client_id
    type                = "web"
    redirect_uris       = [
        "https://global.consent.azure-apim.net/redirect",
        format("https://logic-apis-%s.consent.azure-apim.net/redirect", var.location)
    ]
}

data "local_file" "apiconnection" {
    filename            = "${path.module}/apiconnection.json"
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
            value       = azapi_resource.symbolicname.id
        },
        "location"      = {
            value       = var.location
        }
    })
    deployment_mode = "Incremental"
}

