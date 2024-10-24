# Author: Branden Walter
# Creation Date: September 17th 2024
# ========================
# Description:  Removes the new context menu when you right click in windows 11
#=========================

function Main {
    
    $thisComputer = Get-CimInstance Win32_OperatingSystem

    if ($thisComputer.caption -match "Windows 11") {
        $registryPath = "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
        Start-Process "reg" -ArgumentList "add", "`"$registryPath`"", "/f", "/ve" -NoNewWindow -Wait
        Write-Output "Registry key added successfully."
    } else {
        Write-Output "This script only runs on Windows 11." 
    }
    exit 0
}

Main