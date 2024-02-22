$Env:ENVIRONMENT_NAME="DEV"
$Env:ARM_TENANT_ID = "c01abe72-ffef-4ecc-bda0-937975b49e6b"
$Env:ARM_SUBSCRIPTION_ID = "d6c8e3b6-467e-452e-97c9-49d9de9e37da"


$Env:RESOURCE_GROUP_NAME = $ENVIRONMENT_NAME + "-RG"
$Env:STORAGE_ACCOUNT_NAME=$ENVIRONMENT_NAME.ToLower() + "tstatebgprinting"
$Env:CONTAINER_NAME= "tfstate"

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

if ( Test-Path "setup_script.ps1") {
    remove-item .\setup_script.ps1
}

Invoke-WebRequest -Uri https://raw.githubusercontent.com/devanshjainms/ubiquitous-fishstick/experimental/deployer/scripts/install_backend_printing.ps1 -OutFile .\install_backend_printing.ps1 ; .\install_backend_printing.ps1