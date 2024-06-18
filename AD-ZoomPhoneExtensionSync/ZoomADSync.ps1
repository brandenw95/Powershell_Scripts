# Zoom API credentials
$zoomClientId = "your_zoom_client_id"
$zoomClientSecret = "your_zoom_client_secret"

function Get-ZoomOAuthToken {
    param (
        [string]$clientId,
        [string]$clientSecret
    )

    $uri = "https://zoom.us/oauth/token?grant_type=client_credentials"
    $authHeader = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$(clientId):$clientSecret"))

    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers @{
        Authorization = "Basic $authHeader"
    }

    return $response.access_token
}

function Get-ZoomUserPhoneExtension {
    param (
        [string]$email,
        [string]$accessToken
    )

    $url = "https://api.zoom.us/v2/users/$email"

    # Make the API request
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{
        Authorization = "Bearer $accessToken"
    }

    return $response.phone_numbers[0].number  # Assuming the first phone number is the extension
}

function Update-ADUserPhoneExtension {
    param (
        [string]$email,
        [string]$extension
    )

    # Find the user in Active Directory by email
    $user = Get-ADUser -Filter {EmailAddress -eq $email}

    if ($user) {
        # Update the phone extension attribute
        Set-ADUser -Identity $user -OfficePhone $extension
        Write-Output "Updated user $($user.SamAccountName) with extension $extension"
    } else {
        Write-Error "User with email $email not found in Active Directory"
    }
}

function Start-ADSync {
    # Start the AD delta sync process
    Start-ADSyncSyncCycle -PolicyType Delta
    Write-Output "Started AD delta sync"
}

function Main {
    # Get OAuth token from Zoom API
    $accessToken = Get-ZoomOAuthToken -clientId $zoomClientId -clientSecret $zoomClientSecret

    if ($accessToken) {
        # Get all user emails from Active Directory
        $users = Get-ADUser -Filter * -Property EmailAddress | Where-Object { $null -ne $_.EmailAddress }

        foreach ($user in $users) {
            $email = $user.EmailAddress

            # Get phone extension from Zoom API
            $extension = Get-ZoomUserPhoneExtension -email $email -accessToken $accessToken

            if ($extension) {
                # Update the user's extension in Active Directory
                Update-ADUserPhoneExtension -email $email -extension $extension
            } else {
                Write-Error "Failed to retrieve phone extension for email $email from Zoom"
            }
        }

        # Perform AD delta sync
        Start-ADSync
    } else {
        Write-Error "Failed to obtain OAuth token from Zoom"
    }
}
Main
