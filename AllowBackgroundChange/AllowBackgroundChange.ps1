# Author: Branden Walter
# Date: January 29th 2024
# ========================
# Description: Allows user to change the background manually.
# ========================

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

$script = {
    # This line sets the variable $path to the Background personalization path in the registry.
    $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

    # Grabs all the values in the key "DesktopImagePath"
    $PCSP = Get-ItemProperty $path -Name "DesktopImagePath" -ErrorAction SilentlyContinue

    if (!$null -eq $PCSP) {
        Remove-ItemProperty -Path $path -Name "DesktopImagePath" -Force
    }
}

if ($false -eq (Test-Path "$env:ProgramData\Microsoft\AllowBackgroundPersonalization")) {
    # If script does not exist in directory, store new path to scriptfile variable
    $scriptfile = New-Item -ItemType Directory -Path "$env:ProgramData\Microsoft\AllowBackgroundPersonalization"
}

# Save script to Programdata path 
$script | Out-File -FilePath "$scriptfile\AllowBackgroundPersonalization.ps1"

# Create a Task upon login to allow for wallpaper customization.
$schtaskName = "AllowBackgroundPersonalization"
$schtaskDescription = "Allow changing the background in Intune"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal "NT AUTHORITY\SYSTEM" -RunLevel Highest
$action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-File $scriptfile\AllowBackgroundPersonalization.ps1"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# Register a schedule task (Note:   This part is used to suppress the output of the command that follows. 
#                                   In PowerShell, assigning the output of a command to $null is a common 
#                                   way to execute a command without displaying its output.)

$null=Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force

Start-ScheduledTask -TaskName $schtaskName

$error.clear()
Write-Host "Successfully deleted the registry key and added to startup"
exit 0 
