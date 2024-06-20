function main {
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

main
