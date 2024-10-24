# Author: Branden Walter
# Date: January 26th 2024
# ========================
# Description: Script to remove specified .lnk files from Desktops
# ========================

function Main{
    $filesToDelete = @("VLC media player.lnk", 
                   "Acrobat Reader.lnk", 
                   "Google Chrome.lnk", 
                   "DemoOCX32.lnk", 
                   "DemoOCX64.lnk", 
                   "WinRAR.lnk"
                   ) # Add more filenames as needed


$userDesktop = [System.Environment]::GetFolderPath("Desktop")
$publicDesktop = [System.Environment]::GetFolderPath("CommonDesktopDirectory")

function DeleteFiles {
    param (
        [string]$path
    )

    foreach ($file in $filesToDelete) {
        $fullPath = Join-Path -Path $path -ChildPath $file
        if (Test-Path $fullPath) {
            Remove-Item $fullPath -Force
            Write-Host "Deleted $fullPath"
        } else {
            Write-Host "$fullPath not found"
        }
    }
}

DeleteFiles -path $userDesktop

DeleteFiles -path $publicDesktop

# Clear the STDOUT and STDERR

$error.clear()
Write-Host "Desktop Cleaned up Successfully"
exit 0
}
Main