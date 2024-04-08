function UpdateUserProfilePicture($user) {
    # If the user's profile picture attribute is empty or not set, update it
    if (-not $user.thumbnailPhoto) {

        Set-ADUser -Identity $user -Replace @{thumbnailPhoto=$profilePicture}
        Write-Host "Profile picture added for $($user.Name)"
    }
    else {
        Write-Host "Profile picture already exists for $($user.Name)"
    }
}

function Main {

    # Define the path to the image file
    $scriptDirectory = $PSScriptRoot
    $imagePath = Join-Path -Path $scriptDirectory -ChildPath "profile_picture.jpg"

    # Read the image file and convert it to a byte array
    $profilePicture = [System.IO.File]::ReadAllBytes($imagePath)
    
    $users = Get-ADUser -Filter *
    
    foreach ($user in $users) {
        
        UpdateUserProfilePicture $user
    }
}

Main
