
# Author: Branden Walter
# Date: June 21st 2024
# ========================
# Description: Updates all user in Active Directory with the extension numbers generated in Zoom.
# ========================

$ACCOUNT_ID = $env:ZOOM_ACCOUNT_ID
$CLIENT_ID = $env:ZOOM_CLIENT_ID
$CLIENT_SECRET = $env:ZOOM_CLIENT_SECRET

function ZoomIsInstalled {

    if (-not (Get-Module -ListAvailable -Name PSZoom)) {
        Write-Output "PSZoom module not found. Installing PSZoom module..."
        Install-Module -Name PSZoom -Force -Scope CurrentUser
    } else {
        Write-Output "PSZoom module is already installed."
    }
    
    Import-Module ActiveDirectory
    Import-Module PSZoom
}
function Main {

    # Uncomment the below function when running for the first time.
    #ZoomIsInstalled
    
    Connect-PSZoom -AccountID $ACCOUNT_ID -ClientID $CLIENT_ID -ClientSecret $CLIENT_SECRET
    $users = Get-ADUser -Filter * -Property UserPrincipalName

    foreach ($user in $users) {
        
        # Uncomment this to slow down the API calls
        #Start-Sleep -Seconds 1
        $upn = $user.UserPrincipalName
        try{
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
        catch{ }
    }

    Start-adsyncsynccycle -policytype delta
    exit 0
}
Main