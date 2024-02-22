$Env:CONTROL_PLANE_ENVIRONMENT_CODE="CTRL"
$Env:SAP_ENVIRONMENT="TEST"
$Env:LOCATION="eastus2"
$Env:ARM_TENANT_ID = "0000000-0000-0000-0000-000000000000"
$Env:ARM_SUBSCRIPTION_ID = "0000000-0000-0000-0000-000000000000"
$Env:VIRTUAL_NETWORK_ID = "/subscriptions/0000000-0000-0000-0000-000000000000/resourceGroups/RG/providers/Microsoft.Network/virtualNetworks/VNET"
$Env:SUBNET_ADDRESS_PREFIX = "10.19.4.0/28"

$UniqueIdentifier = Read-Host "Please provide an identifier that makes the service principal names unique, for instance a project code"

$confirmation = Read-Host "Do you want to create a new Application registration (needed for the Web Application) y/n?"
if ($confirmation -eq 'y') {
    $Env:SERVICE_PRINCIPAL_NAME = $UniqueIdentifier + " BG PRINTING APP"
}
else {
    $Env:SERVICE_PRINCIPAL_NAME = Read-Host "Please provide the Application registration name"
}

if ( $PSVersionTable.Platform -eq "Unix") {
    if ( Test-Path "BGPRINT") {
    }
    else {
        $bgprint_path = New-Item -Path "BGPRINT" -Type Directory
    }
}
else {
    $bgprint_path = Join-Path -Path $Env:HOMEDRIVE -ChildPath "BGPRINT"
    if ( Test-Path $bgprint_path) {
    }
    else {
        New-Item -Path $bgprint_path -Type Directory
    }
}

Set-Location -Path $bgprint_path

if ( Test-Path "install_backend_printing.ps1") {
    remove-item .\install_backend_printing.ps1
}

Invoke-WebRequest -Uri https://raw.githubusercontent.com/devanshjainms/ubiquitous-fishstick/experimental/deployer/scripts/install_backend_printing.ps1 -OutFile .\install_backend_printing.ps1 ; .\install_backend_printing.ps1