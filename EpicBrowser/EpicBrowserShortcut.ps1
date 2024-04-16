# Author: Branden Walter
# Date: March 21st 2024
# ========================
# Description: Checks to see if the folowing is installed and desktop icons exist, if not then create desktop icons.
#              - Applied Epic Browser
# ========================

function CreateEpicShortcut {

    #Icon Copy to C and use as icon.
    $iconDestination = "C:\"
    $iconPath = "$PSScriptRoot\EpicBrowser.ico"
    Copy-Item -Path $iconPath -Destination $iconDestination -Force
    $finalIconPath = "C:\EpicBrowser.ico"
    $target = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    $startIn = "C:\Program Files (x86)\Microsoft\Edge\Application"

    $shortcutPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\Applied Epic Browser.lnk"
    
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $target
    $shortcut.Arguments = "-newwindow https://navac01.appliedepic.com/#/"
    $shortcut.WorkingDirectory = $startIn
    $shortcut.IconLocation = $finalIconPath
    $shortcut.Save()

    Write-Host "Icon Saved to Desktop"
    exit 0
}

function Main {
    # If the SHortcut does not exist on the desktop create shortcut
    $IconPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\Applied Epic Browser.lnk"
    if (!(Test-Path $IconPath)) {
        CreateEpicShortcut
    }
    else{
        Write-Host "Icon Already on desktop"
        exit 0 
    }
}
Main
