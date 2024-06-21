
# Author: Branden Walter
# Date: June 21st 2024
# ========================
# Description: Updates all user in Active Directory with the extension numbers generated in Zoom.
# ========================

$ACCOUNT_ID = $env:ZOOM_ACCOUNT_ID
$CLIENT_ID = $env:ZOOM_CLIENT_ID
$CLIENT_SECRET = $env:ZOOM_CLIENT_SECRET

function ZoomIsInstalled {

    """ Check to see if the module is installed, if not install it. """

    if (-not (Get-Module -ListAvailable -Name PSZoom)) {
        Write-Output "PSZoom module not found. Installing PSZoom module..."
        Install-Module -Name PSZoom -Force -Scope CurrentUser
    } else {
        Write-Output "PSZoom module is already installed."
    }
}
function Main {

    """ Grab All Users in AD, Find thier extension in Zoom and then update thier ZipCode AD attribute"""
    
    Import-Module ActiveDirectory
    Import-Module PSZoom

    Connect-PSZoom -AccountID $ACCOUNT_ID -ClientID $CLIENT_ID -ClientSecret $CLIENT_SECRET
    $users = Get-ADUser -Filter * -Property UserPrincipalName

    foreach ($user in $users) {
        
        $upn = $user.UserPrincipalName
        $zoomPhoneUser = Get-ZoomPhoneUser -UserID $upn
        $extensionNumber = $zoomPhoneUser.extension_number
        
        if ($extensionNumber) {
            Set-ADUser -Identity $user -PostalCode $extensionNumber -WhatIf
            Write-Output "Updated user $upn with extension number $extensionNumber"
        } 
        else {
            Write-Output "No extension number found for user $upn"
        }
    }
}
Main
