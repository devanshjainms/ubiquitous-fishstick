#!/bin/bash

$CTRL_ENV_NAME=$Env:CONTROL_PLANE_ENVIRONMENT_CODE
$ARM_TENANT_ID = $Env:ARM_TENANT_ID
$ARM_SUBSCRIPTION_ID = $Env:ARM_SUBSCRIPTION_ID
$SERVICE_PRINCIPAL_NAME = $Env:SERVICE_PRINCIPAL_NAME
$RESOURCE_GROUP_NAME = $Env:CONTROL_PLANE_ENVIRONMENT_CODE + "-RG"
$STORAGE_ACCOUNT_NAME=$Env:CONTROL_PLANE_ENVIRONMENT_CODE.ToLower() + "tstatebgprinting"
$CONTAINER_NAME= "tfstate"
$ACR_NAME = "bgprintingacr"

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

#add redirect uri to the app registration
az ad app update --id $ARM_CLIENT_ID --web-redirect-uris "https://global.consent.azure-apim.net/redirect"

# check if the repository exists
if (Test-Path "ubiquitous-fishstick") {
  Remove-Item "./ubiquitous-fishstick" -Recurse -Force
}

# Clone the git repository
git clone https://github.com/devanshjainms/ubiquitous-fishstick.git
cd "./ubiquitous-fishstick"
git checkout experimental
git pull

# Create the Azure container registry
az acr create --resource-group $RESOURCE_GROUP_NAME --name $ACR_NAME --sku Basic --only-show-errors
az acr login --name $ACR_NAME --expose-token --only-show-errors

# Assign the ACR role to the service principal
az role assignment create --assignee $ARM_CLIENT_ID --role acrpull --subscription $ARM_SUBSCRIPTION_ID --scope /subscriptions/$ARM_SUBSCRIPTION_ID/resourceGroups/$CTRL_ENV_NAME-RG/providers/Microsoft.ContainerRegistry/registries/$ACR_NAME

# Build the docker image using azure container registry
az acr build --registry $ACR_NAME --image bgprinting:latest --file ./backend-printing/Dockerfile ./backend-printing --only-show-errors

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus --only-show-errors

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob --only-show-errors

# Enable limited access to the storage account
az storage account update --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --https-only true --allow-blob-public-access false --only-show-errors

# Create blob container for tfstate
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --only-show-errors

# Get the storage account key
$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

$terraform_key = $CTRL_ENV_NAME + ".terraform.tfstate"
$var_file = "tfvariables.tfvars"
$terraform_directory = "./deployer/terraform"

$Env:TF_VAR_tenant_id = $ARM_TENANT_ID
$Env:TF_VAR_subscription_id = $ARM_SUBSCRIPTION_ID
$Env:TF_VAR_client_id = $ARM_CLIENT_ID
$Env:TF_VAR_client_secret = $ARM_CLIENT_SECRET
$Env:TF_VAR_object_id = $ARM_OBJECT_ID
$Env:TF_VAR_location = $Env:LOCATION
$Env:TF_VAR_environment = $Env:SAP_ENVIRONMENT
$Env:TF_VAR_virtual_network_id = $Env:VIRTUAL_NETWORK_ID
$Env:TF_VAR_subnet_address_prefixes = $Env:SUBNET_ADDRESS_PREFIX
$Env:TF_VAR_container_registry_url = $ACR_NAME + ".azurecr.io"
$Env:TF_VAR_container_image_name = "bgprinting"

# Initialize the backend
terraform -chdir="$terraform_directory" init -reconfigure -upgrade -backend-config="key=$terraform_key" -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME"  -backend-config="resource_group_name=$RESOURCE_GROUP_NAME"  -backend-config="container_name=$CONTAINER_NAME"  -backend-config="tenant_id=$ARM_TENANT_ID" -backend-config="client_id=$ARM_CLIENT_ID" -backend-config="client_secret=$ARM_CLIENT_SECRET" -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"

# Refresh the terraform
terraform -chdir="$terraform_directory"  refresh

# Plan the terraform
terraform -chdir="$terraform_directory" plan -compact-warnings -json -no-color -parallelism=5 -out=tfplan.tfstate 

# Apply the terraform
terraform -chdir="$terraform_directory" apply -auto-approve -compact-warnings -json -no-color -parallelism=5