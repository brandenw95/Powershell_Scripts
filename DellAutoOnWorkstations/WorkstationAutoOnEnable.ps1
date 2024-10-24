# Author: Branden Walter
# Creation Date: September 17th 2024
# Last Modified: September 19th 2024
# ========================
# Description:  Sets the Power management settings for the workstation.
# =========================

$logFile = "C:\temp\logs\PowerManagementSettings.csv"

# Create headers for the CSV file if it does not exist
if (-not (Test-Path $logFile)) {
    "Path,Value" | Set-Content -Path $logFile
}

function Log {
    param (
        [string]$path,
        [string]$value
    )
    $logEntry = "$path,$value"
    $logEntry | Set-Content -Path $logFile
}

function InstallDellBIOSProviderModule {
    if (-not (Get-Module -ListAvailable -Name DellBIOSProvider)) {
        #Log "Module Installation" "Installing DellBIOSProvider module and NuGet Module..."
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
        Install-Module -Name DellBIOSProvider -Force -AllowClobber | Out-Null
        #Log "Module Installation" "DellBIOSProvider module installation completed."
    } else {
        #Log "Module Installation" "DellBIOSProvider module is already installed."
    }
}

function ImportDellBIOSProviderModule {
    if (-not (Get-Module -Name DellBIOSProvider)) {
        #Log "Module Import" "Importing DellBIOSProvider module..."
        Import-Module DellBIOSProvider
        #Log "Module Import" "DellBIOSProvider module import completed."
    } else {
        #Log "Module Import" "DellBIOSProvider module is already imported."
    }
}

function SetPowerManagementSetting {
    param (
        [string]$Path,
        [string]$Value
    )
    #Log "Setting $Path" $Value
    Set-Item -Path "DellSmbios:\PowerManagement\$Path" -Value $Value
    Log "$Path" "$Value"
}

function Main {
    if (-not (Test-Path "C:\temp\logs")) {
        New-Item -Path "C:\temp\logs" -ItemType Directory
    }

    InstallDellBIOSProviderModule
    ImportDellBIOSProviderModule

    SetPowerManagementSetting -Path "BlockSleep" -Value "Enabled"
    SetPowerManagementSetting -Path "AcPwrRcvry" -Value "On"
    SetPowerManagementSetting -Path "AutoOn" -Value "Everyday"
    SetPowerManagementSetting -Path "AutoOnHr" -Value "01"
    SetPowerManagementSetting -Path "AutoOnMn" -Value "00"

    exit 0
}

Main
