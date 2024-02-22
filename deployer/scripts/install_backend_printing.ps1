#!/bin/bash

$ENV_NAME="DEV"
$ARM_TENANT_ID = "c01abe72-ffef-4ecc-bda0-937975b49e6b"
$ARM_SUBSCRIPTION_ID = "d6c8e3b6-467e-452e-97c9-49d9de9e37da"
$RESOURCE_GROUP_NAME = $ENV_NAME + "-RG"
$STORAGE_ACCOUNT_NAME=$ENV_NAME.ToLower() + "tstate" + $ENV_NAME.ToLower()
$CONTAINER_NAME= "tfstate"
$SERVICE_PRINCIPAL_NAME = "DEVANSH-BGPRINTING-SPN1"

# Logout and then login to Azure
az logout
az account clear

if ($ARM_TENANT_ID.Length -eq 0) {
  az login --output none --only-show-errors
}
else {
  az login --output none --tenant $ARM_TENANT_ID --only-show-errors
}

az config set extension.use_dynamic_install=yes_without_prompt --only-show-errors

if ($ARM_SUBSCRIPTION_ID.Length -eq 0) {
  Write-Host "$ARM_SUBSCRIPTION_ID is not set!" -ForegroundColor Red
  $ARM_SUBSCRIPTION_ID = Read-Host "Please enter a subscription ID"
}

az account set --subscription $ARM_SUBSCRIPTION_ID
$ARM_SUBSCRIPTION_NAME = (az account show --query name -o tsv)

$app_registration = (az ad sp list --all --filter "startswith(displayName,'$SERVICE_PRINCIPAL_NAME')" --query "[?displayName=='$SERVICE_PRINCIPAL_NAME'].displayName | [0]" --only-show-errors)

$scopes = "/subscriptions/$ARM_SUBSCRIPTION_ID"

if ($app_registration.Length -gt 0) {
  Write-Host "Found an existing Service Principal:" $SERVICE_PRINCIPAL_NAME
  $ExistingData = (az ad sp list --all --filter "startswith(displayName,'$SERVICE_PRINCIPAL_NAME')" --query  "[?displayName=='$SERVICE_PRINCIPAL_NAME']| [0]" --only-show-errors) | ConvertFrom-Json

  $ARM_CLIENT_ID = $ExistingData.appId
  $ARM_OBJECT_ID = $ExistingData.Id
  $ARM_TENANT_ID = $ExistingData.appOwnerOrganizationId

  $confirmation = Read-Host "Reset the Service Principal password y/n?"
  if ($confirmation -eq 'y') {

    $ARM_CLIENT_SECRET = (az ad sp credential reset --id $ARM_CLIENT_ID --append --query "password" --out tsv --only-show-errors).Replace("""", "")
  }
  else
  {
    $ARM_CLIENT_SECRET = Read-Host "Please enter the Service Principal password"
  }

}
else {
  Write-Host "Creating the Service Principal" $SERVICE_PRINCIPAL_NAME -ForegroundColor Green
  $SPN_DATA = (az ad sp create-for-rbac --role "Contributor" --scopes $scopes --name $SERVICE_PRINCIPAL_NAME --only-show-errors) | ConvertFrom-Json
  Write-Host "Service Principal Name:" $SERVICE_PRINCIPAL_NAME

  $ARM_CLIENT_SECRET = $SPN_DATA.password
  $ExistingData = (az ad sp list --all --filter "startswith(displayName,'$SERVICE_PRINCIPAL_NAME')" --query  "[?displayName=='$SERVICE_PRINCIPAL_NAME'] | [0]" --only-show-errors) | ConvertFrom-Json
  $ARM_CLIENT_ID = $ExistingData.appId
  $ARM_TENANT_ID = $ExistingData.appOwnerOrganizationId
  $ARM_OBJECT_ID = $ExistingData.Id
}
Write-Host "Service Principal Name:" $SERVICE_PRINCIPAL_NAME
az role assignment create --assignee $ARM_CLIENT_ID --role "Contributor" --subscription $ARM_SUBSCRIPTION_ID --scope /subscriptions/$ARM_SUBSCRIPTION_ID --output none
az role assignment create --assignee $ARM_CLIENT_ID --role "User Access Administrator" --subscription $ARM_SUBSCRIPTION_ID --scope /subscriptions/$ARM_SUBSCRIPTION_ID --output none

# Create the Azure container registry
az acr create ==resource_group $RESOURCE_GROUP_NAME --name "bgprintingacr" --sku Basic --only-show-errors
az acr login --name "bgprintingacr" --only-show-errors

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus --only-show-errors

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob --only-show-errors

# Enable limited access to the storage account
az storage account update --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --https-only true --allow-blob-public-access false --only-show-errors

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --only-show-errors

# Get the storage account key
$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

$terraform_key = $ENV + ".terraform.tfstate"
$var_file = "tfvariables.tfvars"
$terraform_directory = "../terraform"

# Initialize the backend
terraform -chdir="$terraform_directory" init -reconfigure -upgrade -backend-config="key=$terraform_key" -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME"  -backend-config="resource_group_name=$RESOURCE_GROUP_NAME"  -backend-config="container_name=$CONTAINER_NAME"  -backend-config="tenant_id=$ARM_TENANT_ID" -backend-config="client_id=$ARM_CLIENT_ID" -backend-config="client_secret=$ARM_CLIENT_SECRET" -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"

# Refresh the terraform
terraform -chdir="$terraform_directory"  refresh -var-file="${var_file}" -var "tenant_id=$ARM_TENANT_ID" -var "subscription_id=$ARM_SUBSCRIPTION_ID" -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "object_id=$ARM_OBJECT_ID"

# Plan the terraform
terraform -chdir="$terraform_directory"  plan  -var-file="${var_file}" -var "tenant_id=$ARM_TENANT_ID" -var "subscription_id=$ARM_SUBSCRIPTION_ID" -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "object_id=$ARM_OBJECT_ID" -compact-warnings -json -no-color -parallelism=5 -out=tfplan.tfstate

# Apply the terraform
terraform -chdir="$terraform_directory"  apply -parallelism="10" -var-file="${var_file}" -json -auto-approve -var "tenant_id=$ARM_TENANT_ID" -var "subscription_id=$ARM_SUBSCRIPTION_ID" -var "client_id=$ARM_CLIENT_ID" -var "client_secret=$ARM_CLIENT_SECRET" -var "object_id=$ARM_OBJECT_ID" -compact-warnings -json -no-color -parallelism=5