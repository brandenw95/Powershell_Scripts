# Author: Branden Walter
# Date: March 27th 2024
# ========================
# Description: Detection script for Telus Business connect.
# ========================

function Main {
    $installPath = "C:\Users\$env:username\AppData\Local\Programs\TELUSBusinessConnect"
    $exePath = "$installPath\resources.pak"

    if (Test-Path $exePath) {
        Write-Output "Program Installed."
        exit 1
    } else {
        Write-Output "Program Removed."
        exit 0
    }
}
Main