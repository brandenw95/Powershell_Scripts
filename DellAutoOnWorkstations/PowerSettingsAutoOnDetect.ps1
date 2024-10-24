# Author: Branden Walter
# Creation Date: September 20th 2024
# Last Modified: September 20th 2024
# ========================
# Description:  Detects the change to the power settings.
#=========================

function Main {
    
    # Check if DellBIOSProvider module is installed
    $moduleName = "DellBIOSProvider"
    $moduleInstalled = Get-Module -ListAvailable | Where-Object { $_.Name -eq $moduleName }

    if (-not $moduleInstalled) {
        Write-Output "DellBIOSProvider module is not installed."
        exit 1
    }

    # Try importing the module
    try {
        Import-Module DellBIOSProvider -ErrorAction Stop
        Write-Output "DellBIOSProvider module imported successfully."
    } catch {
        Write-Output "Failed to import DellBIOSProvider module."
        exit 1
    }

    # Function to check if a BIOS setting is applied
    function CheckBiosSetting {
        param (
            [string]$Path,
            [string]$ExpectedValue
        )
        $item = Get-ItemProperty -Path $Path
        if ($item.Value -ne $ExpectedValue) {
            Write-Output "$Path is not set to $ExpectedValue."
            return $false
        }
        return $true
    }

    # Check the power settings
    $allSettingsApplied = $true

    if (-not (CheckBiosSetting -Path "DellSmbios:\PowerManagement\BlockSleep" -ExpectedValue "Enabled")) {
        $allSettingsApplied = $false
    }

    if (-not (CheckBiosSetting -Path "DellSmbios:\PowerManagement\AcPwrRcvry" -ExpectedValue "On")) {
        $allSettingsApplied = $false
    }

    if (-not (CheckBiosSetting -Path "DellSmbios:\PowerManagement\AutoOn" -ExpectedValue "Everyday")) {
        $allSettingsApplied = $false
    }

    if (-not (CheckBiosSetting -Path "DellSmbios:\PowerManagement\AutoOnHr" -ExpectedValue "01")) {
        $allSettingsApplied = $false
    }

    if (-not (CheckBiosSetting -Path "DellSmbios:\PowerManagement\AutoOnMn" -ExpectedValue "00")) {
        $allSettingsApplied = $false
    }

    # Exit status based on the verification results
    if ($allSettingsApplied) {
        Write-Output "All settings are applied successfully."
        exit 0
    } else {
        Write-Output "Some settings are not applied correctly."
        exit 1
    }

}

Main
