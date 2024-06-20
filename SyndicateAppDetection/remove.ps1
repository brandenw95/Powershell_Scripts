# Author: Branden Walter
# Date: June 20th 2024
# ========================
# Description: Removes the syndicate app if the detection script triggers it in intune.
# ========================
function main {

    $folder = "C:\temp\SyndicateApp"
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcut = "$desktop\Syndicate Split Tool.lnk"

    if (Test-Path $folder) {
        Remove-Item -Path $folder -Recurse -Force
        Write-Output "Folder removed: $folder"
    } 
    else {
        Write-Output "Folder not found: $folder"
    }

    if (Test-Path $shortcut) {
        Remove-Item -Path $shortcut -Force
        Write-Output "Shortcut removed: $shortcut"
    } 
    else {
        Write-Output "Shortcut not found: $shortcut"
    }
    exit 0
}
Main 