
# Author: Branden Walter
# Date: June 24th 2024
# ========================
# Description: Updates all user in Active Directory with the extension numbers generated in Zoom.
# ========================

$ACCOUNT_ID = $env:ZOOM_ACCOUNT_ID
$CLIENT_ID = $env:ZOOM_CLIENT_ID
$CLIENT_SECRET = $env:ZOOM_CLIENT_SECRET

$ROOT_OU = "OU=VII Locations,DC=vii,DC=local"

function ZoomIsInstalled {
    <# Check to see if the module is installed, if not install it. #>

    if (-not (Get-Module -ListAvailable -Name PSZoom)) {
        Write-Output "PSZoom module not found. Installing PSZoom module..."
        Install-Module -Name PSZoom -Force -Scope CurrentUser
    } else {
        Write-Output "PSZoom module is already installed."
    }
    Import-Module PSZoom
}

function Update-ADUsersFromZoom {
    param (
        [string]$OUPath
    )

    Write-Output "Updating users in $OUPath..."
    
    # Retrieve all users in the current OU
    $users = Get-ADUser -Filter * -SearchBase $OUPath -SearchScope OneLevel -Property UserPrincipalName
    
    foreach ($user in $users) {
        Write-Output "Processing user: $($user.UserPrincipalName)"
        
        if ($user -and ($user -like "*@waypoint.ca")) {
            try {
                $zoomPhoneUser = Get-ZoomPhoneUser -UserID $user.UserPrincipalName
                $extensionNumber = $zoomPhoneUser.extension_number
                Write-Output "EXTENSION NUMBER: $extensionNumber"

                if ($extensionNumber) {
                    Set-ADUser -Identity $user -PostalCode $extensionNumber -WhatIf
                    Write-Output "Updated user $($user.UserPrincipalName) with extension number $extensionNumber"
                } else {
                    Write-Output "No extension number found for user $($user.UserPrincipalName)"
                }
            } catch {
                Write-Error "Failed to retrieve or update information for user $($user.UserPrincipalName). Error: $_"
            }
        }
    }

    # Get all child OUs under the current OU
    $childOUs = Get-ADOrganizationalUnit -Filter * -SearchBase $OUPath -SearchScope OneLevel
    
    foreach ($childOU in $childOUs) {
        Update-ADUsersFromZoom -OUPath $childOU.DistinguishedName
        
    }
}

function Main {

    Write-Output "Connecting to Zoom..."
    Connect-PSZoom -AccountID $ACCOUNT_ID -ClientID $CLIENT_ID -ClientSecret $CLIENT_SECRET
    Write-Output "Done."

    Update-ADUsersFromZoom -OUPath $ROOT_OU

    Write-Output "Ran Successfully"
    exit 0
}

#ZoomIsInstalled
Main
