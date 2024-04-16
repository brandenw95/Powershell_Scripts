# Author: Branden Walter
# Date: March 21st 2024
# ========================
# Description: Checks to see if the folowing is installed and desktop icons exist, if not then create desktop icons.
#              - Policy Works
# ========================

function CreatePolicyWorksShortcut {
    $username = $env:USERNAME
    $shortcutName = "Applied Policy Works (Applied Cloud)"
    $NewShortcutName = "Policy Works"
    $sourcePath = "C:\Users\$username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Applied Cloud (RADC)\$shortcutName.lnk"
    $destinationPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\$NewShortcutName.lnk"

    if ((Test-Path $sourcePath) -And -Not (Test-Path $destinationPath)) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force
        Write-Host "Policy Works shortcut applied"
        exit 0
    }
    elseif (Test-Path $destinationPath) {
        Write-Host "Shortcut '$shortcutName' already exists on Desktop."
        exit 0
    } 
    else {
        Write-Host "Policy Works Not Installed"
        exit 0
    }
}

CreatePolicyWorksShortcut