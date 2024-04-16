# Author: Branden Walter
# Date: March 21st 2024
# ========================
# Description: Checks to see if the folowing is installed and desktop icons exist, if not then create desktop icons.
#              - Policy Works
# ========================

function CreatePolicyWorksShortcut {

    # Define folder and file paths
    $folderPath = "C:\ASI\PolicyWorks"
    $shortcutFolder = "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Applied Cloud (RADC)"
    $originalShortcutPath = Join-Path -Path $shortcutFolder -ChildPath "Applied Policy Works (Applied Cloud).lnk"
    $newShortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("CommonDesktopDirectory"), "Policy Works.lnk")

    if ((Test-Path -Path $folderPath -PathType Container) -and (Test-Path -Path $originalShortcutPath -PathType Leaf)) {
        Copy-Item -Path $originalShortcutPath -Destination $newShortcutPath -Force
        exit 0
    } 
    else{
        Remove-Item -Path $newShortcutPath -Force
        exit 0
    }
    exit 0
    
}

CreatePolicyWorksShortcut