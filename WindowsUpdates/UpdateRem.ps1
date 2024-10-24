# Author: Branden Walter
# Creation Date: September 17th 2024
# ========================
# Description:  Runs widnows updates
#=========================

function Install-NuGetAndPSWindowsUpdate {
    try {
        # Install NuGet if it's not installed
        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
        }
        # Install PSWindowsUpdate module if not installed
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
            Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
        }
        Import-Module PSWindowsUpdate
    } catch {
        Write-Output "Failed to install NuGet or PSWindowsUpdate module. Error: $_"
        exit 1
    }
}

function Main {
    $logFile = "C:\temp\logs\WindowsUpdateLog.txt"
    
    Install-NuGetAndPSWindowsUpdate
    
    try {
        # Install updates, accept all, and suppress reboot
        Install-WindowsUpdate -AcceptAll -IgnoreReboot | Tee-Object -FilePath $logFile | Write-Output
        Write-Output "Windows updates installed successfully."
        exit 0
    } catch {
        Write-Output "Failed to install Windows updates. Error: $_"
        exit 1
    }
}

Main
