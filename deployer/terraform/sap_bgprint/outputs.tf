output "resource_group_id" {
    description = "The id of the resource group"
    value       = azurerm_resource_group.rg.id
}

output "managed_identity_id" {
    description = "The id of the managed identity"
    value       = azurerm_user_assigned_identity.msi.id
}

output "key_vault_id" {
    description = "The id of the key vault"
    value       = azurerm_key_vault.kv.id
}
