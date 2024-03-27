$Env:CONTROL_PLANE_ENVIRONMENT_CODE="CTRL"
$Env:WORKLOAD_ENV_NAME="TEST"
$Env:LOCATION=""
$Env:ARM_TENANT_ID = ""
$Env:ARM_SUBSCRIPTION_ID = ""
$Env:SAP_VIRTUAL_NETWORK_ID = ""
$Env:BGPRINT_SUBNET_ADDRESS_PREFIX = ""
$Env:ENABLE_LOGGING_ON_FUNCTION_APP = $false

$UniqueIdentifier = Read-Host "Please provide an identifier that makes the service principal names unique, for exaple (MGMT/CTRL)"

$confirmation = Read-Host "Do you want to create a new Application registration for Control Plane (needed for the Web Application) y/n?"
if ($confirmation -eq 'y') {
    $Env:CONTROL_PLANE_SERVICE_PRINCIPAL_NAME = $UniqueIdentifier + "-SAP-PRINT-APP"
}
else {
    $Env:CONTROL_PLANE_SERVICE_PRINCIPAL_NAME = Read-Host "Please provide the Application registration name"
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