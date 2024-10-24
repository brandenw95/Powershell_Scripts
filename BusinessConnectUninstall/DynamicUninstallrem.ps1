# Author: Branden Walter
# Date: March 27th 2024
# ========================
# Description: Searches the computer for Telus Business connect installer and removes it.
# ========================
function Main {
    $uninstallFileName = "Uninstall TELUS Business Connect.exe"
    $currentUserAppData = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    
    $currentUserAppData = Split-Path -Path $currentUserAppData
    
    Get-ChildItem -Path $currentUserAppData -Filter $uninstallFileName -Recurse -ErrorAction SilentlyContinue -Force |
        ForEach-Object {
            $uninstallerPath = $_.FullName
            Write-Output "Found uninstaller at: $uninstallerPath"
            Start-Process -FilePath $uninstallerPath -ArgumentList "/S" -NoNewWindow -Wait
            Write-Output "Successfully ran installer silently"
            exit 0
        }
}
Main
