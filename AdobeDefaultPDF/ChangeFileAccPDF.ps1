# Author: Branden Walter
# Date: March 26th 2024
# ========================
# Description: Changes the file association for PDFs
# ========================

# Check if Adobe Reader is installed
if (Test-Path "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe") {
    # Set the path to Adobe Reader executable
    $adobeReaderPath = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
    
    # Set the file extension
    $fileExtension = ".pdf"
    
    # Change the default association
    $defaultAssoc = New-Object -ComObject WScript.Shell
    $defaultAssoc.RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$fileExtension\UserChoice", "", "REG_SZ")
    $defaultAssoc.RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$fileExtension\UserChoice\ProgId", "Acrobat.Document.DC", "REG_SZ")
    #$defaultAssoc.RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$fileExtension\UserChoice\Application", $adobeReaderPath, "REG_SZ")
    
    Write-Host "Default file association for $fileExtension changed to Adobe Reader."
} else {
    Write-Host "Adobe Reader is not installed."
}