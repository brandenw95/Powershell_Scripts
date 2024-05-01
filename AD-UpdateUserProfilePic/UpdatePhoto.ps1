# Author: Branden Walter
# Date: April 17th 2024
# ========================
# Description: Changes the profile of users in Active Directory
#
#   !! Important!!
#
#   Image must adhere to the following spec:
#       - Must be 96 x 96 pixels
#       - Less than 100kb in file size
#
# ========================

#Users that already have profile pictures set 
$emailsToSkip = @(
    "email1@email.com",
    "email2@email.com"
)


$allUsers = Get-ADUser -Filter * -Properties SamAccountName, UserPrincipalName
$photo = [byte[]](Get-Content "C:\Temp\profile2024.png" -Encoding byte)

foreach ($user in $allUsers) {

    $upn = $user.UserPrincipalName
    $sam = $user.SamAccountName
    
    if ($upn -and $emailsToSkip -notcontains $upn) {
        Set-ADUser -Identity $sam -Replace @{thumbnailPhoto=$photo}
        Write-Host "User $($sam) has been updated"
    }
    else{
    
        Write-Host "SKIPPED: $upn"

    }
}