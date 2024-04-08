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
        [System.Object[]] $user
        
    )
    #[Microsoft.ActiveDirectory.Management.ADUser] $user-one
    $scriptDirectory = $PSScriptRoot
    $imagePath = Join-Path -Path $scriptDirectory -ChildPath "profile2024.png"
    $profilePicture = [System.IO.File]::ReadAllBytes($imagePath)

    # If the user's profile picture attribute is empty or not set, update it
    if (-not $user.thumbnailPhoto) {

        Set-ADUser -Identity $user -Replace @{thumbnailPhoto=$profilePicture}
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



    # Test User 1
    $testUser1 = New-Object PSObject -Property @{
        Name = "John Doe"
        # No thumbnail photo
        thumbnailPhoto = $null 
    }

    #Test User 2
    $testUser2 = New-Object PSObject -Property @{
        Name = "Jane Smith"
        # Existing thumbnail photo
        thumbnailPhoto = [byte[]]@(1, 2, 3) 
    }

    $testUsers = @($testUser1, $testUser2)

    $users = $testUsers
    #$users = Get-ADUser -Filter *
    Write-Output "Type of myVariable: $($users.GetType())"
    
    foreach ($user in $users) {
        
        UpdateUserProfilePicture -user $users
    }
}

Main
