# Author: Branden Walter
# Date: April 8th 2024
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

function UpdateUserProfilePicture{
    param (
        [Parameter]
        [Microsoft.ActiveDirectory.Management.ADUser] $user
        
    )
    
    $scriptDirectory = $PSScriptRoot
    $imagePath = Join-Path -Path $scriptDirectory -ChildPath "profile2024.png"
    $profilePicture = [System.IO.File]::ReadAllBytes($imagePath)

    # If the user's profile picture attribute is empty or not set, update it.
    if (-not $user.thumbnailPhoto) {

        Set-ADUser -Identity $user -Replace @{thumbnailPhoto=$profilePicture} -WhatIf
        Write-Host "Profile picture added for $($user.Name)"
    }
    else {
        Write-Host "Profile picture already exists for $($user.Name)"
    }
}
function init_warning {
    Write-Output "!!Important!!"
    Write-Output "Image must adhere to the following spec:"
    Write-Output "- Less than 100kb in file size"
    Write-Output "- Must be 96 x 96 pixels"
}
function Main {

    $users = Get-ADUser -Filter *
    
    foreach ($user in $users) {
        
        UpdateUserProfilePicture -user $users
    }
}

Main
