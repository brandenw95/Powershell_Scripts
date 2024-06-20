# Author: Branden Walter
# Date: June 20th 2024
# ========================
# Description: Detects the install of the Syndicate app.
# ========================

function Main{

    $file = "C:\temp\SyndicateApp\main.py"
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcut = "$desktop\Syndicate Split Tool.lnk"

    if (Test-Path $file) {
        Write-Output "File found: $file"
        exit 1
    } 
    else {
        Write-Output "File not found: $file"
        exit 0
    }

    if (Test-Path $shortcut) {
        Write-Output "Shortcut found: $shortcut"
        exit 1
    } 
    else {
        Write-Output "Shortcut not found: $shortcut"
        exit 0
    }

}

Main