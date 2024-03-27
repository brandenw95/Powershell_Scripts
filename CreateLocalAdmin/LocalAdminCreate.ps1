# Author: Branden Walter
# Date: March 26th 2024
# ========================
# Description: Creates a local admin account on the workstation.
# ========================

$username = "USERNAME"
$password = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force
$User = New-LocalUser -Name $username -Password $password -FullName "Local Admin Account" -Description "Local administrator account" -AccountNeverExpires
Add-LocalGroupMember -Group "Administrators" -Member $username
Write-Host "Local administrator account '$username' has been created successfully."

$error.clear()
Write-Host "Successfully Deleted the Registry key and added to startup"
exit 0 