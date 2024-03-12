data "local_file" "apiconnection" {
    filename            = "${path.module}/apiconnection.json"
}

resource "azurerm_resource_group_template_deployment" "apiconnection" {
    name                = format("%s%s", "upgraph-connection", lower(random_string.random.result))
    resource_group_name = azurerm_resource_group.rg.name
    template_content    = data.local_file.apiconnection.content
    parameters_content  = jsonencode({
        "apiconnection_name" = {
            value       = format("%s%s", "upgraph-connection", lower(random_string.random.result))
        },
        "customapiResourceId" = {
            value       = azapi_resource.symbolicname.id
        },
        "location"      = {
            value       = var.location
        }
    })
    deployment_mode = "Incremental"
}