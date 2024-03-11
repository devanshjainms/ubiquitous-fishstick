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
            displayName = "Microsoft Universal Print Custom Connector",
            iconUri = "https://content.powerapps.com/resource/makerx/static/media/default-connection-icon.74fb37fa.svg",
            apiType = "Rest"
            # apiDefinition = {
            #     type = "swagger",
            #     specification = {
            #         type = "openapi",
            #         definition = <<DEFINITION
            #             {
            #                 "swagger": "2.0",
            #                 "info": {
            #                     "title": "Microsoft Graph",
            #                     "version": "v1.0"
            #                 },
            #                 "host": "graph.microsoft.com",
            #                 "schemes": [
            #                     "https"
            #                 ],
            #                 "paths": {
            #                     "/me": {
            #                         "get": {
            #                             "operationId": "GetMyProfile",
            #                             "responses": {
            #                                 "200": {
            #                                     "description": "Success"
            #                                 }
            #                             }
            #                         }
            #                     }
            #                 },
            #                 "definitions": {
            #                     "User": {
            #                         "type": "object",
            #                         "properties": {
            #                             "id": {
            #                                 "type": "string"
            #                             },
            #                             "displayName": {
            #                                 "type": "string"
            #                             }
            #                         }
            #                     }
            #                 }
            #             }
            #         DEFINITION
            #     }
            # }
            apiDefinition = {
                originalSwaggerUrl = "https://ctrltstatebgprinting.blob.core.windows.net/swagger/UniversalPrintGraphSwagger.json"
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
        swagger: '2.0'
        info:
        title: Microsoft Graph Rest APIs for Universal Print
        description: Microsoft Graph Rest APIs for Universal Print
        version: v1.0
        host: graph.microsoft.com
        basePath: /
        schemes:
        - https
        consumes: []
        produces: []
        paths:
        /v1.0/print/shares/{printerShareId}:
            get:
            summary: Get printer share by id
            description: Get printer share by id
            operationId: PrinterShares_GetPrinterShare
            produces:
                - application/json
            parameters:
                - in: path
                name: printerShareId
                description: printer share Id
                required: true
                type: string
            responses:
                '200':
                description: Get printer share by id
                schema:
                    type: array
                    items:
                    $ref: '#/definitions/microsoft.graph.PrinterShare'
                '400':
                description: BadRequest
                '401':
                description: Unauthorized
                '403':
                description: Forbidden
                '500':
                description: InternalServerError
        /v1.0/print/shares/{printerShareId}/jobs:
            post:
            summary: Create printer job from printer share
            description: Create printer job from printer share
            operationId: PrinterShares_PostToJobsFromPrinterShare
            consumes:
                - application/json
            produces:
                - application/json
            parameters:
                - in: path
                name: printerShareId
                description: printer share Id
                required: true
                type: string
                - in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/microsoft.graph.printJob'
            responses:
                '200':
                description: Create printer job from printer share
                schema:
                    type: array
                    items:
                    $ref: '#/definitions/microsoft.graph.printJob'
                '400':
                description: BadRequest
                '401':
                description: Unauthorized
                '403':
                description: Forbidden
                '500':
                description: InternalServerError
        /v1.0/print/shares/{printerShareId}/jobs/{jobId}/start:
            post:
            summary: Start printer job
            description: Start printer job
            operationId: PrinterShares_StartPrintJob
            produces:
                - application/json
            parameters:
                - in: path
                name: printerShareId
                description: printer share Id
                required: true
                type: string
                - in: path
                name: jobId
                description: job Id
                required: true
                type: string
            responses:
                '200':
                description: Start printer job
                schema:
                    type: array
                    items:
                    $ref: '#/definitions/microsoft.graph.printJobStatus'
                '400':
                description: BadRequest
                '401':
                description: Unauthorized
                '403':
                description: Forbidden
                '500':
                description: InternalServerError
        /v1.0/print/shares/{printerShareId}/jobs/{jobId}/documents/{documentId}/createUploadSession:
            post:
            summary: Create upload session for printer share
            description: Create upload session for printer share
            operationId: PrinterShares_CreateUploadSession
            consumes:
                - application/json
            produces:
                - application/json
            parameters:
                - in: path
                name: printerShareId
                description: printer share Id
                required: true
                type: string
                - in: path
                name: jobId
                description: job Id
                required: true
                type: string
                - in: path
                name: documentId
                description: document Id
                required: true
                type: string
                - in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/microsoft.graph.PrintDocumentUploadProperties'
            responses:
                '200':
                description: Create upload session for printer share
                schema:
                    type: array
                    items:
                    $ref: '#/definitions/microsoft.graph.UploadSession'
                '400':
                description: BadRequest
                '401':
                description: Unauthorized
                '403':
                description: Forbidden
                '500':
                description: InternalServerError
        definitions:
        microsoft.graph.PrinterShare:
            properties:
            viewPoint:
                $ref: '#/definitions/microsoft.graph.PrinterShareViewpoint'
            allowAllUsers:
                description: allowAllUsers
                type: boolean
            createdDateTime:
                description: createdDateTime
                type: string
            id:
                description: id
                type: string
            name:
                description: name
                type: string
            displayName:
                description: displayName
                type: string
            manufacturer:
                description: manufacturer
                type: string
            model:
                description: model
                type: string
            status:
                $ref: '#/definitions/microsoft.graph.printerStatus'
            location:
                $ref: '#/definitions/microsoft.graph.printerLocation'
            isAcceptingJobs:
                description: isAcceptingJobs
                type: boolean
            defaults:
                $ref: '#/definitions/microsoft.graph.printerDefaults'
            capabilities:
                $ref: '#/definitions/microsoft.graph.printerCapabilities'
        microsoft.graph.PrinterShareViewpoint:
            properties:
            lastUsedDateTime:
                description: lastUsedDateTime
                type: string
        microsoft.graph.printerStatus:
            properties:
            processingState:
                description: processingState
                type: string
            state:
                description: state
                type: string
            processingStateReasons:
                description: processingStateReasons
                type: array
                items:
                type: string
            details:
                description: details
                type: array
                items:
                type: string
            processingStateDescription:
                description: processingStateDescription
                type: string
            description:
                description: description
                type: string
        microsoft.graph.printerLocation:
            properties:
            latitude:
                description: latitude
                type: number
            longitude:
                description: longitude
                type: number
            altitudeInMeters:
                description: altitudeInMeters
                type: integer
            streetAddress:
                description: streetAddress
                type: string
            subunit:
                description: subunit
                type: array
                items:
                type: string
            city:
                description: city
                type: string
            region:
                description: region
                type: array
                items:
                type: string
            postalCode:
                description: postalCode
                type: string
            country:
                description: country
                type: string
            site:
                description: site
                type: string
            building:
                description: building
                type: string
            floorNumber:
                description: floorNumber
                type: integer
            floor:
                description: floor
                type: string
            floorDescription:
                description: floorDescription
                type: string
            roomNumber:
                description: roomNumber
                type: integer
            roomName:
                description: roomName
                type: string
            roomDescription:
                description: roomDescription
                type: string
            organization:
                description: organization
                type: array
                items:
                type: string
            subdivision:
                description: subdivision
                type: array
                items:
                type: string
            stateOrProvince:
                description: stateOrProvince
                type: string
            countryOrRegion:
                description: countryOrRegion
                type: string
        microsoft.graph.printerDefaults:
            properties:
            copiesPerJob:
                description: copiesPerJob
                type: integer
            finishings:
                description: finishings
                type: array
                items:
                type: string
            mediaColor:
                description: mediaColor
                type: string
            mediaType:
                description: mediaType
                type: string
            mediaSize:
                description: mediaSize
                type: string
            pagesPerSheet:
                description: pagesPerSheet
                type: integer
            orientation:
                description: orientation
                type: string
            outputBin:
                description: outputBin
                type: string
            inputBin:
                description: inputBin
                type: string
            documentMimeType:
                description: documentMimeType
                type: string
            pdfFitToPage:
                description: pdfFitToPage
                type: boolean
            duplexConfiguration:
                description: duplexConfiguration
                type: string
            presentationDirection:
                description: presentationDirection
                type: string
            printColorConfiguration:
                description: printColorConfiguration
                type: string
            printQuality:
                description: printQuality
                type: string
            contentType:
                description: contentType
                type: string
            fitPdfToPage:
                description: fitPdfToPage
                type: boolean
            multipageLayout:
                description: multipageLayout
                type: string
            colorMode:
                description: colorMode
                type: string
            quality:
                description: quality
                type: string
            duplexMode:
                description: duplexMode
                type: string
            dpi:
                description: dpi
                type: integer
            scaling:
                description: scaling
                type: string
        microsoft.graph.printerCapabilities:
            properties:
            isColorPrintingSupported:
                description: isColorPrintingSupported
                type: boolean
            supportsFitPdfToPage:
                description: supportsFitPdfToPage
                type: boolean
            supportedCopiesPerJob:
                $ref: '#/definitions/microsoft.graph.integerRange'
            supportedDocumentMimeTypes:
                description: supportedDocumentMimeTypes
                type: array
                items:
                type: string
            supportedFinishings:
                description: supportedFinishings
                type: array
                items:
                type: string
            supportedMediaColors:
                description: supportedMediaColors
                type: array
                items:
                type: string
            supportedMediaTypes:
                description: supportedMediaTypes
                type: array
                items:
                type: string
            supportedMediaSizes:
                description: supportedMediaSizes
                type: array
                items:
                type: string
            supportedPagesPerSheet:
                $ref: '#/definitions/microsoft.graph.integerRange'
            supportedOrientations:
                description: supportedOrientations
                type: array
                items:
                type: string
            supportedOutputBins:
                description: supportedOutputBins
                type: array
                items:
                type: string
            supportedDuplexConfigurations:
                description: supportedDuplexConfigurations
                type: array
                items:
                type: string
            supportedPresentationDirections:
                description: supportedPresentationDirections
                type: array
                items:
                type: string
            supportedColorConfigurations:
                description: supportedColorConfigurations
                type: array
                items:
                type: string
            supportedPrintQualities:
                description: supportedPrintQualities
                type: array
                items:
                type: string
            contentTypes:
                description: contentTypes
                type: array
                items:
                type: string
            feedOrientations:
                description: feedOrientations
                type: array
                items:
                type: string
            feedDirections:
                description: feedDirections
                type: array
                items:
                type: string
            isPageRangeSupported:
                description: isPageRangeSupported
                type: boolean
            qualities:
                description: qualities
                type: array
                items:
                type: string
            dpis:
                description: dpis
                type: array
                items:
                type: integer
            duplexModes:
                description: duplexModes
                type: array
                items:
                type: string
            copiesPerJob:
                $ref: '#/definitions/microsoft.graph.integerRange'
            finishings:
                description: finishings
                type: array
                items:
                type: string
            mediaColors:
                description: mediaColors
                type: array
                items:
                type: string
            mediaTypes:
                description: mediaTypes
                type: array
                items:
                type: string
            mediaSizes:
                description: mediaSizes
                type: array
                items:
                type: string
            pagesPerSheet:
                description: pagesPerSheet
                type: array
                items:
                type: integer
            orientations:
                description: orientations
                type: array
                items:
                type: string
            outputBins:
                description: outputBins
                type: array
                items:
                type: string
            multipageLayouts:
                description: multipageLayouts
                type: array
                items:
                type: string
            colorModes:
                description: colorModes
                type: array
                items:
                type: string
            inputBins:
                description: inputBins
                type: array
                items:
                type: string
            topMargins:
                description: topMargins
                type: array
                items:
                type: integer
            bottomMargins:
                description: bottomMargins
                type: array
                items:
                type: integer
            rightMargins:
                description: rightMargins
                type: array
                items:
                type: integer
            leftMargins:
                description: leftMargins
                type: array
                items:
                type: integer
            collation:
                description: collation
                type: boolean
            scalings:
                description: scalings
                type: array
                items:
                type: string
        microsoft.graph.printJob:
            properties:
            id:
                description: id
                type: string
            createdBy:
                $ref: '#/definitions/microsoft.graph.UserIdentity'
            createdDateTime:
                description: createdDateTime
                type: string
            isFetchable:
                description: isFetchable
                type: boolean
            status:
                $ref: '#/definitions/microsoft.graph.printJobStatus'
            redirectedFrom:
                description: redirectedFrom
                type: string
            redirectedTo:
                description: redirectedTo
                type: string
            configuration:
                $ref: '#/definitions/microsoft.graph.printJobConfiguration'
            displayName:
                description: displayName
                type: string
            errorCode:
                description: errorCode
                type: integer
            acknowledgedDateTime:
                description: acknowledgedDateTime
                type: string
            completedDateTime:
                description: completedDateTime
                type: string
        microsoft.graph.printJobStatus:
            properties:
            processingState:
                description: processingState
                type: string
            state:
                description: state
                type: string
            processingStateDescription:
                description: processingStateDescription
                type: string
            description:
                description: description
                type: string
            wasJobAcquiredByPrinter:
                description: wasJobAcquiredByPrinter
                type: boolean
            isAcquiredByPrinter:
                description: isAcquiredByPrinter
                type: boolean
            details:
                description: details
                type: array
                items:
                type: string
        microsoft.graph.PrintDocumentUploadProperties:
            properties:
            contentType:
                description: contentType
                type: string
            documentName:
                description: documentName
                type: string
            size:
                description: size
                type: integer
        microsoft.graph.UploadSession:
            properties:
            expirationDateTime:
                description: expirationDateTime
                type: string
            nextExpectedRanges:
                description: nextExpectedRanges
                type: array
                items:
                type: string
            uploadUrl:
                description: uploadUrl
                type: string
            oDataType:
                description: oDataType
                type: string
        microsoft.graph.printJobConfiguration:
            properties:
            pageRanges:
                description: pageRanges
                type: array
                items:
                $ref: '#/definitions/microsoft.graph.integerRange'
            quality:
                description: quality
                type: string
            dpi:
                description: dpi
                type: integer
            feedOrientation:
                description: feedOrientation
                type: string
            orientation:
                description: orientation
                type: string
            duplexMode:
                description: duplexMode
                type: string
            copies:
                description: copies
                type: integer
            colorMode:
                description: colorMode
                type: string
            inputBin:
                description: inputBin
                type: string
            outputBin:
                description: outputBin
                type: string
            mediaSize:
                description: mediaSize
                type: string
            margin:
                $ref: '#/definitions/microsoft.graph.printMargin'
            mediaType:
                description: mediaType
                type: string
            finishings:
                description: finishings
                type: array
                items:
                type: string
            pagesPerSheet:
                description: pagesPerSheet
                type: integer
            multipageLayout:
                description: multipageLayout
                type: string
            collate:
                description: collate
                type: boolean
            scaling:
                description: scaling
                type: string
            fitPdfToPage:
                description: fitPdfToPage
                type: boolean
        microsoft.graph.integerRange:
            properties:
            start:
                description: start
                type: integer
            end:
                description: end
                type: integer
            minimum:
                description: minimum
                type: integer
            maximum:
                description: maximum
                type: integer
        microsoft.graph.printMargin:
            properties:
            top:
                description: top
                type: integer
            bottom:
                description: bottom
                type: integer
            left:
                description: left
                type: integer
            right:
                description: right
                type: integer
        microsoft.graph.UserIdentity:
            properties:
            id:
                description: id
                type: string
            displayName:
                description: displayName
                type: string
            ipAddress:
                description: ipAddress
                type: string
            userPrincipalName:
                description: userPrincipalName
                type: string
            oDataType:
                description: oDataType
                type: string
        parameters: {}
        responses: {}
        securityDefinitions: {}
        security: []
        tags: []

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
