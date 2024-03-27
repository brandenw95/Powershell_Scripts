# Original Author: Jascha Mager
# Formatting: Branden Walter
# Date: January 26th 2024
# ========================
# Description: Downloads wallpaper and lockscreen image from URL and sets on workstation.
# ========================

$WallpaperURL = "https://www.seafirstinsurance.com/wp-content/uploads/2024/01/SFI-Navacord-Desktop-Background.jpg"
$LockscreenUrl = "https://www.seafirstinsurance.com/wp-content/uploads/2024/01/SFI-Navacord-Desktop-Background.jpg"
$ImageDestinationFolder = "c:\Intune\Pictures"
$WallpaperDestinationFile = "$ImageDestinationFolder\wallpaperV1.jpg"
$LockScreenDestinationFile = "$ImageDestinationFolder\LockScreenV1.jpg"

# Creates the destination folder on the target computer
mkdir $ImageDestinationFolder -erroraction silentlycontinue

# Downloads the image file from the source location
Start-BitsTransfer -Source $WallpaperURL -Destination "$WallpaperDestinationFile"
Start-BitsTransfer -Source $LockscreenUrl -Destination "$LockScreenDestinationFile"

# Assigns the wallpaper 
$RegKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'

$DesktopPath = "DesktopImagePath"
$DesktopStatus = "DesktopImageStatus"
$DesktopUrl = "DesktopImageUrl"
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"

$StatusValue = "1"
$DesktopImageValue = "$WallpaperDestinationFile"  
$LockScreenImageValue = "$LockScreenDestinationFile"

if(!(Test-Path $RegKeyPath)){

    New-Item -Path $RegKeyPath -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $DesktopStatus -Value $StatusValue -Type DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $StatusValue -Type DWORD -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $DesktopPath -Value $DesktopImageValue -Type STRING -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $DesktopUrl -Value $DesktopImageValue -Type STRING -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Value $LockScreenImageValue -Type STRING -Force | Out-Null
    New-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Value $LockScreenImageValue -Type STRING -Force | Out-Null
}

else {

    Set-ItemProperty -Path $RegKeyPath -Name $DesktopStatus -Value $Statusvalue -Type DWORD -Force | Out-Null
    Set-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $value -Type DWORD -Force | Out-Null
    Set-ItemProperty -Path $RegKeyPath -Name $DesktopPath -Value $DesktopImageValue -Type STRING -Force | Out-Null
    Set-ItemProperty -Path $RegKeyPath -Name $DesktopUrl -Value $DesktopImageValue -Type STRING -Force | Out-Null
    Set-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Value $LockScreenImageValue -Type STRING -Force | Out-Null
    Set-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Value $LockScreenImageValue -Type STRING -Force | Out-Null
}

# Clear STDERR
$error.clear()
Write-Host "Desktop Wallpaper has Been changed successfully"
exit 0 