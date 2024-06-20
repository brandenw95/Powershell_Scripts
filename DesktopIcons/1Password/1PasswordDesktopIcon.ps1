# Author: Branden Walter
# Date: April 26th 2024
# ========================
# Description: Checks to see if the following is installed and desktop icons exist, if not then create desktop icons.
#              - 1Password
# ========================

function Main {

    $target = "C:\Program Files\1Password\app\8\1Password.exe"
    $startIn = "C:\Program Files\1Password\app\8\"
    $shortcutPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\1Password.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $target
    $shortcut.Arguments = ""
    $shortcut.WorkingDirectory = $startIn
    $shortcut.Save()
    Write-Output "Icon on Desktop"
    exit 0

}
Main
