# Author: Branden Walter
# Creation Date: September 17th 2024
# ========================
# Description:  Removes the New Outlook (Outlook for Windows)
#=========================

function Main {
    
    $newOutlookPackage = Get-AppxPackage | Where-Object { $_.Name -like "*Microsoft.OutlookForWindows*" }

    if ($newOutlookPackage) {
        
        Remove-AppxPackage -Package $newOutlookPackage.PackageFullName
        Write-Output "New Outlook has been removed successfully."
    } else {
        Write-Output "New Outlook is not installed on this machine."
    }
    exit 0
}
Main
