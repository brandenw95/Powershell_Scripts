# Author: Branden Walter
# Date: March 27th 2024
# ========================
# Description: Direct Uninstaller for Telus Business connect.
# ========================

function Main {
    $userprofile = [Environment]::UserName
    $installPath = "C:\Users\$userprofile\AppData\Local\Programs\TELUSBusinessConnect"
    $exePath = "$installPath\Uninstall TELUS Business Connect.exe"

    if (Test-Path $exePath) {
        Start-Process -FilePath $exePath -ArgumentList "/S" -Wait
        Write-Output "Successfully Uninstalled"
        exit 0
    } 
}
Main