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
            },
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
            displayName = "Microsoft Universal Print Custom Connector",
            iconUri = "https://content.powerapps.com/resource/makerx/static/media/default-connection-icon.74fb37fa.svg",
            apiType = "Rest",
            swagger = {
                "swagger" : "2.0",
                "info": {
                "title": "Microsoft Graph Rest APIs for Universal Print",
                "description": "Microsoft Graph Rest APIs for Universal Print",
                "version": "v1.0"
                },
                "servers": [
                    {
                    "url": "https://graph.microsoft.com/"
                    }
                ],
                "paths": {
                    "/v1.0/print/shares/{printerShareId}": {
                        "get": {
                            "summary": "Get printer share by id",
                            "description": "Get printer share by id",
                            "operationId": "PrinterShares_GetPrinterShare",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "description": "printer share Id",
                                    "required": true,
                                    "schema": {
                                        "type": "string"
                                    }
                                }
                            ],
                            "responses": {
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
                                },
                                "200": {
                                    "description": "Get printer share by id",
                                    "content": {
                                        "application/json": {
                                            "schema": {
                                                "type": "array",
                                                "items": {
                                                    "$ref": "#/components/schemas/microsoft.graph.PrinterShare"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs": {
                        "post": {
                            "summary": "Create printer job from printer share",
                            "description": "Create printer job from printer share",
                            "operationId": "PrinterShares_PostToJobsFromPrinterShare",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "description": "printer share Id",
                                    "required": true,
                                    "schema": {
                                        "type": "string"
                                    }
                                }
                            ],
                            "requestBody": {
                                "content": {
                                    "application/json": {
                                        "schema": {
                                            "$ref": "#/components/schemas/microsoft.graph.printJob"
                                        }
                                    }
                                },
                                "required": true
                            },
                            "responses": {
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
                                },
                                "200": {
                                    "description": "Create printer job from printer share",
                                    "content": {
                                        "application/json": {
                                            "schema": {
                                                "type": "array",
                                                "items": {
                                                    "$ref": "#/components/schemas/microsoft.graph.printJob"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs/{jobId}/start": {
                        "post": {
                            "summary": "Start printer job",
                            "description": "Start printer job",
                            "operationId": "PrinterShares_StartPrintJob",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "description": "printer share Id",
                                    "required": true,
                                    "schema": {
                                        "type": "string"
                                    }
                                },
                                {
                                    "name": "jobId",
                                    "in": "path",
                                    "description": "job Id",
                                    "required": true,
                                    "schema": {
                                        "type": "string"
                                    }
                                }
                            ],
                            "responses": {
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
                                },
                                "200": {
                                    "description": "Start printer job",
                                    "content": {
                                        "application/json": {
                                            "schema": {
                                                "type": "array",
                                                "items": {
                                                    "$ref": "#/components/schemas/microsoft.graph.printJobStatus"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    "/v1.0/print/shares/{printerShareId}/jobs/{jobId}/documents/{documentId}/createUploadSession": {
                        "post": {
                            "summary": "Create upload session for printer share",
                            "description": "Create upload session for printer share",
                            "operationId": "PrinterShares_CreateUploadSession",
                            "parameters": [
                                {
                                    "name": "printerShareId",
                                    "in": "path",
                                    "description": "printer share Id",
                                    "required": true,
                                    "schema": {
                                        "type": "string"
                                    }
                                },
                                {
                                    "name": "jobId",
                                    "in": "path",
                                    "description": "job Id",
                                    "required": true,
                                    "schema": {
                                        "type": "string"
                                    }
                                },
                                {
                                    "name": "documentId",
                                    "in": "path",
                                    "description": "document Id",
                                    "required": true,
                                    "schema": {
                                        "type": "string"
                                    }
                                }
                            ],
                            "requestBody": {
                                "content": {
                                    "application/json": {
                                        "schema": {
                                            "$ref": "#/components/schemas/microsoft.graph.PrintDocumentUploadProperties"
                                        }
                                    }
                                },
                                "required": true
                            },
                            "responses": {
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
                                },
                                "200": {
                                    "description": "Create upload session for printer share",
                                    "content": {
                                        "application/json": {
                                            "schema": {
                                                "type": "array",
                                                "items": {
                                                    "$ref": "#/components/schemas/microsoft.graph.UploadSession"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                "components": {
                    "schemas": {
                        "microsoft.graph.PrinterShare": {
                            "properties": {
                                "viewPoint": {
                                    "$ref": "#/components/schemas/microsoft.graph.PrinterShareViewpoint"
                                },
                                "allowAllUsers": {
                                    "type": "boolean",
                                    "description": "allowAllUsers"
                                },
                                "createdDateTime": {
                                    "type": "string",
                                    "description": "createdDateTime"
                                },
                                "id": {
                                    "type": "string",
                                    "description": "id"
                                },
                                "name": {
                                    "type": "string",
                                    "description": "name"
                                },
                                "displayName": {
                                    "type": "string",
                                    "description": "displayName"
                                },
                                "manufacturer": {
                                    "type": "string",
                                    "description": "manufacturer"
                                },
                                "model": {
                                    "type": "string",
                                    "description": "model"
                                },
                                "status": {
                                    "$ref": "#/components/schemas/microsoft.graph.printerStatus"
                                },
                                "location": {
                                    "$ref": "#/components/schemas/microsoft.graph.printerLocation"
                                },
                                "isAcceptingJobs": {
                                    "type": "boolean",
                                    "description": "isAcceptingJobs"
                                },
                                "defaults": {
                                    "$ref": "#/components/schemas/microsoft.graph.printerDefaults"
                                },
                                "capabilities": {
                                    "$ref": "#/components/schemas/microsoft.graph.printerCapabilities"
                                }
                            }
                        },
                        "microsoft.graph.PrinterShareViewpoint": {
                            "properties": {
                                "lastUsedDateTime": {
                                    "type": "string",
                                    "description": "lastUsedDateTime"
                                }
                            }
                        },
                        "microsoft.graph.printerStatus": {
                            "properties": {
                                "processingState": {
                                    "type": "string",
                                    "description": "processingState"
                                },
                                "state": {
                                    "type": "string",
                                    "description": "state"
                                },
                                "processingStateReasons": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "processingStateReasons"
                                },
                                "details": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "details"
                                },
                                "processingStateDescription": {
                                    "type": "string",
                                    "description": "processingStateDescription"
                                },
                                "description": {
                                    "type": "string",
                                    "description": "description"
                                }
                            }
                        },
                        "microsoft.graph.printerLocation": {
                            "properties": {
                                "latitude": {
                                    "type": "number",
                                    "description": "latitude"
                                },
                                "longitude": {
                                    "type": "number",
                                    "description": "longitude"
                                },
                                "altitudeInMeters": {
                                    "type": "integer",
                                    "description": "altitudeInMeters"
                                },
                                "streetAddress": {
                                    "type": "string",
                                    "description": "streetAddress"
                                },
                                "subunit": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "subunit"
                                },
                                "city": {
                                    "type": "string",
                                    "description": "city"
                                },
                                "region": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "region"
                                },
                                "postalCode": {
                                    "type": "string",
                                    "description": "postalCode"
                                },
                                "country": {
                                    "type": "string",
                                    "description": "country"
                                },
                                "site": {
                                    "type": "string",
                                    "description": "site"
                                },
                                "building": {
                                    "type": "string",
                                    "description": "building"
                                },
                                "floorNumber": {
                                    "type": "integer",
                                    "description": "floorNumber"
                                },
                                "floor": {
                                    "type": "string",
                                    "description": "floor"
                                },
                                "floorDescription": {
                                    "type": "string",
                                    "description": "floorDescription"
                                },
                                "roomNumber": {
                                    "type": "integer",
                                    "description": "roomNumber"
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
                                },
                                "countryOrRegion": {
                                    "type": "string",
                                    "description": "countryOrRegion"
                                }
                            }
                        },
                        "microsoft.graph.printerDefaults": {
                            "properties": {
                                "copiesPerJob": {
                                    "type": "integer",
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
                                "documentMimeType": {
                                    "type": "string",
                                    "description": "documentMimeType"
                                },
                                "pdfFitToPage": {
                                    "type": "boolean",
                                    "description": "pdfFitToPage"
                                },
                                "duplexConfiguration": {
                                    "type": "string",
                                    "description": "duplexConfiguration"
                                },
                                "presentationDirection": {
                                    "type": "string",
                                    "description": "presentationDirection"
                                },
                                "printColorConfiguration": {
                                    "type": "string",
                                    "description": "printColorConfiguration"
                                },
                                "printQuality": {
                                    "type": "string",
                                    "description": "printQuality"
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
                                    "description": "dpi"
                                },
                                "scaling": {
                                    "type": "string",
                                    "description": "scaling"
                                }
                            }
                        },
                        "microsoft.graph.printerCapabilities": {
                            "properties": {
                                "isColorPrintingSupported": {
                                    "type": "boolean",
                                    "description": "isColorPrintingSupported"
                                },
                                "supportsFitPdfToPage": {
                                    "type": "boolean",
                                    "description": "supportsFitPdfToPage"
                                },
                                "supportedCopiesPerJob": {
                                    "$ref": "#/components/schemas/microsoft.graph.integerRange"
                                },
                                "supportedDocumentMimeTypes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedDocumentMimeTypes"
                                },
                                "supportedFinishings": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedFinishings"
                                },
                                "supportedMediaColors": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedMediaColors"
                                },
                                "supportedMediaTypes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedMediaTypes"
                                },
                                "supportedMediaSizes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedMediaSizes"
                                },
                                "supportedPagesPerSheet": {
                                    "$ref": "#/components/schemas/microsoft.graph.integerRange"
                                },
                                "supportedOrientations": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedOrientations"
                                },
                                "supportedOutputBins": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedOutputBins"
                                },
                                "supportedDuplexConfigurations": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedDuplexConfigurations"
                                },
                                "supportedPresentationDirections": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedPresentationDirections"
                                },
                                "supportedColorConfigurations": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedColorConfigurations"
                                },
                                "supportedPrintQualities": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "supportedPrintQualities"
                                },
                                "contentTypes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "contentTypes"
                                },
                                "feedOrientations": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "feedOrientations"
                                },
                                "feedDirections": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "feedDirections"
                                },
                                "isPageRangeSupported": {
                                    "type": "boolean",
                                    "description": "isPageRangeSupported"
                                },
                                "qualities": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "qualities"
                                },
                                "dpis": {
                                    "type": "array",
                                    "items": {
                                        "type": "integer"
                                    },
                                    "description": "dpis"
                                },
                                "duplexModes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "duplexModes"
                                },
                                "copiesPerJob": {
                                    "$ref": "#/components/schemas/microsoft.graph.integerRange"
                                },
                                "finishings": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "finishings"
                                },
                                "mediaColors": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "mediaColors"
                                },
                                "mediaTypes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "mediaTypes"
                                },
                                "mediaSizes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "mediaSizes"
                                },
                                "pagesPerSheet": {
                                    "type": "array",
                                    "items": {
                                        "type": "integer"
                                    },
                                    "description": "pagesPerSheet"
                                },
                                "orientations": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "orientations"
                                },
                                "outputBins": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "outputBins"
                                },
                                "multipageLayouts": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "multipageLayouts"
                                },
                                "colorModes": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "colorModes"
                                },
                                "inputBins": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "inputBins"
                                },
                                "topMargins": {
                                    "type": "array",
                                    "items": {
                                        "type": "integer"
                                    },
                                    "description": "topMargins"
                                },
                                "bottomMargins": {
                                    "type": "array",
                                    "items": {
                                        "type": "integer"
                                    },
                                    "description": "bottomMargins"
                                },
                                "rightMargins": {
                                    "type": "array",
                                    "items": {
                                        "type": "integer"
                                    },
                                    "description": "rightMargins"
                                },
                                "leftMargins": {
                                    "type": "array",
                                    "items": {
                                        "type": "integer"
                                    },
                                    "description": "leftMargins"
                                },
                                "collation": {
                                    "type": "boolean",
                                    "description": "collation"
                                },
                                "scalings": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "scalings"
                                }
                            }
                        },
                        "microsoft.graph.printJob": {
                            "properties": {
                                "id": {
                                    "type": "string",
                                    "description": "id"
                                },
                                "createdBy": {
                                    "$ref": "#/components/schemas/microsoft.graph.UserIdentity"
                                },
                                "createdDateTime": {
                                    "type": "string",
                                    "description": "createdDateTime"
                                },
                                "isFetchable": {
                                    "type": "boolean",
                                    "description": "isFetchable"
                                },
                                "status": {
                                    "$ref": "#/components/schemas/microsoft.graph.printJobStatus"
                                },
                                "redirectedFrom": {
                                    "type": "string",
                                    "description": "redirectedFrom"
                                },
                                "redirectedTo": {
                                    "type": "string",
                                    "description": "redirectedTo"
                                },
                                "configuration": {
                                    "$ref": "#/components/schemas/microsoft.graph.printJobConfiguration"
                                },
                                "displayName": {
                                    "type": "string",
                                    "description": "displayName"
                                },
                                "errorCode": {
                                    "type": "integer",
                                    "description": "errorCode"
                                },
                                "acknowledgedDateTime": {
                                    "type": "string",
                                    "description": "acknowledgedDateTime"
                                },
                                "completedDateTime": {
                                    "type": "string",
                                    "description": "completedDateTime"
                                }
                            }
                        },
                        "microsoft.graph.printJobStatus": {
                            "properties": {
                                "processingState": {
                                    "type": "string",
                                    "description": "processingState"
                                },
                                "state": {
                                    "type": "string",
                                    "description": "state"
                                },
                                "processingStateDescription": {
                                    "type": "string",
                                    "description": "processingStateDescription"
                                },
                                "description": {
                                    "type": "string",
                                    "description": "description"
                                },
                                "wasJobAcquiredByPrinter": {
                                    "type": "boolean",
                                    "description": "wasJobAcquiredByPrinter"
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
                        "microsoft.graph.PrintDocumentUploadProperties": {
                            "properties": {
                                "contentType": {
                                    "type": "string",
                                    "description": "contentType"
                                },
                                "documentName": {
                                    "type": "string",
                                    "description": "documentName"
                                },
                                "size": {
                                    "type": "integer",
                                    "description": "size"
                                }
                            }
                        },
                        "microsoft.graph.UploadSession": {
                            "properties": {
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
                                },
                                "uploadUrl": {
                                    "type": "string",
                                    "description": "uploadUrl"
                                },
                                "oDataType": {
                                    "type": "string",
                                    "description": "oDataType"
                                }
                            }
                        },
                        "microsoft.graph.printJobConfiguration": {
                            "properties": {
                                "pageRanges": {
                                    "type": "array",
                                    "items": {
                                        "$ref": "#/components/schemas/microsoft.graph.integerRange"
                                    },
                                    "description": "pageRanges"
                                },
                                "quality": {
                                    "type": "string",
                                    "description": "quality"
                                },
                                "dpi": {
                                    "type": "integer",
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
                                "margin": {
                                    "$ref": "#/components/schemas/microsoft.graph.printMargin"
                                },
                                "mediaType": {
                                    "type": "string",
                                    "description": "mediaType"
                                },
                                "finishings": {
                                    "type": "array",
                                    "items": {
                                        "type": "string"
                                    },
                                    "description": "finishings"
                                },
                                "pagesPerSheet": {
                                    "type": "integer",
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
                            }
                        },
                        "microsoft.graph.integerRange": {
                            "properties": {
                                "start": {
                                    "type": "integer",
                                    "description": "start"
                                },
                                "end": {
                                    "type": "integer",
                                    "description": "end"
                                },
                                "minimum": {
                                    "type": "integer",
                                    "description": "minimum"
                                },
                                "maximum": {
                                    "type": "integer",
                                    "description": "maximum"
                                }
                            }
                        },
                        "microsoft.graph.printMargin": {
                            "properties": {
                                "top": {
                                    "type": "integer",
                                    "description": "top"
                                },
                                "bottom": {
                                    "type": "integer",
                                    "description": "bottom"
                                },
                                "left": {
                                    "type": "integer",
                                    "description": "left"
                                },
                                "right": {
                                    "type": "integer",
                                    "description": "right"
                                }
                            }
                        },
                        "microsoft.graph.UserIdentity": {
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
                                },
                                "oDataType": {
                                    "type": "string",
                                    "description": "oDataType"
                                }
                            }
                        }
                    }
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
