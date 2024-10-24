# Author: Branden Walter
# Date: April 26th 2024
# ========================
# Description: Installs the 64 bit version of adobe.
# ========================

function Write-Log {
    param(
        [string]$Message
    )

    $logFile = "C:\Temp\UninstallAndInstallAdobe.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $Message"
}

function Main{

    Write-Log "Script started."

    $url = "https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/win32/Acrobat_DC_Web_x64_WWMUI.zip"
    $zipFilePath = "C:\temp\Acrobat_DC_Web_x64_WWMUI.zip"
    $extractPath = "C:\temp\"
    $setupExePath = "C:\temp\Adobe Acrobat\Setup.exe"
    
    # Download the zip file
    Invoke-WebRequest -Uri $url -OutFile $zipFilePath | wait-Process
    Write-Log "downloaded zip"
    
    Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
    Write-Log "extracted zip"
    $guid = "{AC76BA86-7AD7-1033-7B44-AC0F074E4100}"
    
    $application = Get-WmiObject -Class Win32_Product | Where-Object { $_.IdentifyingNumber -eq $guid }
    $application.Uninstall()
    Write-Log "Application with GUID $guid has been uninstalled successfully."
    
    Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force | Wait-Process
    
    Start-Process -FilePath $setupExePath -ArgumentList "/sAll" | wait-process
    Write-Log "Adobe Reader 64-bit installed successfully."

    Remove-Item -Path $zipFilePath
    Remove-Item -Path "C:\temp\Adobe Acrobat" -Recurse -Force

    Write-Log "Script completed. zip file deleted"

    exit 0
}

Main
