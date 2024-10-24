# Author: Branden Walter
# Creation Date: September 17th 2024
# ========================
# Description:  Trigger, Log and do Windows Updates
#=========================

function InitialChecks {
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Install-Module -Name PSWindowsUpdate -Force | Out-File -FilePath $logFile -Append
    }

    if (-not (Get-Module -Name PSWindowsUpdate)) {
        Import-Module PSWindowsUpdate | Out-File -FilePath $logFile -Append
    }
}
function LogMessage {
    param (
        [string]$message
    )
        
    $logFile = "C:\temp\logs\WinUpdates.txt"

    Write-Output "$message"

    if (-not (Test-Path -Path "C:\temp\logs")) {
        New-Item -ItemType Directory -Path "C:\temp\logs"
    }
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append

}
function Main {
    
    try{
        $logFile = "C:\temp\logs\WinUpdates.txt"

        LogMessage "#############################"
        LogMessage "Starting Windows Update script."

        InitialChecks
        LogMessage "Getting list of available updates."
        Get-WUList | Out-File -FilePath $logFile -Append

        #LogMessage "Installing updates."
        #Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot | Out-File -FilePath $logFile -Append

        LogMessage "Windows Update script completed."
        LogMessage "#############################"
        #Write-Output "Updates Complete"
        exit 0
    }
    catch{
        Write-Output "Something went wrong."
        exit 1
    }
}

Main
