
$imagePath = ".\profile_picture.jpg"

$profilePicture = [System.IO.File]::ReadAllBytes($imagePath)

$users = Get-ADUser -Filter *

foreach ($user in $users) {
    # Check if the user has a value set for the Specific thumbnail photo attribute
    if (-not $user.thumbnailPhoto) {
        Set-ADUser -Identity $user -Replace @{thumbnailPhoto=$profilePicture}
        Write-Host "Profile picture added for $($user.Name)"
    }
    else {
        Write-Host "Profile picture already exists for $($user.Name)"
    }
}  