# Author: Branden Walter
# Date: March 21st 2024
# ========================
# Description: Checks to see if the following is installed and desktop icons exist, if not then create desktop icons.
#              - Applied Epic Browser
# ========================


function downloadIcon{

    $headers = @{"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"}
    $url = "https://www.seafirstinsurance.com/wp-content/uploads/2024/03/EpicBrowser.ico"
    $directoryPath = "C:\temp"
    $outputDirectory = "C:\temp\EpicBrowser.ico"

    if (-not (Test-Path $directoryPath)) {
        New-Item -Path $directoryPath -ItemType Directory -Force
    } else {
        Write-Host "Directory already exists: $directoryPath" > $null
    }
    Invoke-WebRequest -Uri $url -Headers $headers -OutFile $outputDirectory
}
function CreateEpicShortcut {

    $finalIconPath = "C:\temp\EpicBrowser.ico"
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

    downloadIcon
    # If the Shortcut does not exist on the desktop create shortcut
    $IconPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\Applied Epic Browser.lnk"
    if (!(Test-Path $IconPath)) {
        CreateEpicShortcut
    }
    else{
        Write-Host "Icon Already on Desktop"
        exit 0 
    }
}
Main
