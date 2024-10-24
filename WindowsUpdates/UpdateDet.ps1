# Author: Branden Walter
# Creation Date: September 17th 2024
# ========================
# Description:  Detects if there are any more windows updates
#=========================

function Install-NuGetAndPSWindowsUpdate {
    try {

        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
        }
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
            Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
        }
        Import-Module PSWindowsUpdate
    } catch {
        Write-Output "Failed to install NuGet or PSWindowsUpdate module. Error: $_"
        exit 1
    }
}

function EnsureLogFileExists {
    param (
        [string]$logFilePath
    )

    $logDirectory = [System.IO.Path]::GetDirectoryName($logFilePath)

    if (-not (Test-Path $logDirectory)) {
        try {

            New-Item -Path $logDirectory -ItemType Directory -Force
            Write-Output "Directory created: $logDirectory"
        } catch {
            Write-Output "Failed to create directory: $logDirectory. Error: $_"
            exit 1
        }
    }

    if (-not (Test-Path $logFilePath)) {
        try {
            New-Item -Path $logFilePath -ItemType File -Force
            Write-Output "Log file created: $logFilePath"
        } catch {
            Write-Output "Failed to create log file: $logFilePath. Error: $_"
            exit 1
        }
    }
}

function Main {
    $logFile = "C:\temp\logs\WindowsUpdateLog.txt"
    
    Install-NuGetAndPSWindowsUpdate

    EnsureLogFileExists -logFilePath $logFile

    try {
        $updates = Get-WUList

        $updates | Tee-Object -FilePath $logFile | Write-Output

        if ($updates.Count -eq 0) {
            Write-Output "No updates available."
            exit 1
        } else {
            Write-Output "Updates are available."
            exit 0
        }
    } catch {
        Write-Output "Failed to retrieve Windows update list. Error: $_"
        exit 1
    }
}

Main
