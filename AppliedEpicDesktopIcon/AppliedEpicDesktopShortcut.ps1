# Author: Branden Walter
# Date: March 27th 2024
# ========================
# Description: Creates a desktop icon for Applied Epic.
# ========================

function Main{
    
    $publicDesktopPath = [System.IO.Path]::Combine($env:PUBLIC, 'Desktop')
    $targetPath = "C:\ASI\ASI.TAM\ThinClient\Software\ASI.SMART.Client.Frame.exe Home"
    $shortcutName = "Applied Epic 2022.lnk"
    $shortcutPath = [System.IO.Path]::Combine($publicDesktopPath, $shortcutName)
    
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Save()
    
    $shortcutContent = Get-Content $shortcutPath
    $shortcutContent = $shortcutContent -replace '"', ''
    Set-Content -Path $shortcutPath -Value $shortcutContent
    
    Write-Host "Shortcut created at: $shortcutPath"
    exit 0
    
}
Main