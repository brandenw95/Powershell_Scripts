function main {
    $uninstallFileName = "Uninstall TELUS Business Connect.exe"
    $currentUserAppData = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData)
    $found = $false
    $currentUserAppData = Split-Path -Path $currentUserAppData
    
    Get-ChildItem -Path $currentUserAppData -Filter $uninstallFileName -Recurse -ErrorAction SilentlyContinue -Force |
        ForEach-Object {
            $found = $true
            $uninstallerPath = $_.FullName
            Write-Output "Found uninstaller at: $uninstallerPath"
        }
        
    if ($found) {
        Write-Output "Installer found"
        exit 0
    } else {
        Write-Output "Installer not found"
        exit 1
    }
}

main
