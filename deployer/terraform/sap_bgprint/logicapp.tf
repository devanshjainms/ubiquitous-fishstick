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

resource "azurerm_logic_app_action_custom" "logic_app_action_get_printer_share" {
    name                = "GetPrinterShare"
    logic_app_id        = azurerm_logic_app_workflow.logic_app.id
    body                = <<BODY
    {
        "inputs": {
            "method": "GET",
            "uri": "https://api.printer.com/share"
        },
        "runAfter": {},
        "metadata": {
            "flowSystemMetadata": {
                "swaggerOperationId": "GetPrinterShare"
            }
        }
    }
    BODY
}