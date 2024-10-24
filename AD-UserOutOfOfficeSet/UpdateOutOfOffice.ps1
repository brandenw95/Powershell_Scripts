# Author: Branden Walter
# Creation Date: April 16th 2024
# ========================
# Description:  Automate the setup of Out of Office (OOO) responses in Microsoft Exchange
#               for users. The script can handle individual or bulk OOO setup, pulling user
#               data from BambooHR, ensuring the process is seamless and efficient.
#
# Exit Codes:
#               0 - Success - Indicates successful setup of OOO messages.
#               1 - Incorrect Usage - Indicates incorrect usage or invalid parameters.
#               2 - Exchange Connectivity Failed - Indicates failure in connecting or authenticating with Microsoft Exchange.
#               3 - Invalid Parameter - Indicates invalid parameters provided to the script.
#
#=========================
$API_KEY = "API KEY"
$AZURETHUMBPRINT = "Thumb print Key "
$APP_ID = "3e60bdcf-5ace-4280-81e6-754cdaac10e9"
$ORGANIZATION = "seafirstinsurance.onmicrosoft.com"
function APIGetDataBambooHR{

    # Authenticate, Query the API and return all Out of Office data
    $headers=@{}
    $authentication_api = $API_KEY
    $headers.Add("Accept", "application/json")
    $headers.Add("authorization", "Basic $authentication_api")
    $response = Invoke-WebRequest -Uri 'https://api.bamboohr.com/api/gateway.php/seafirstinsurance/v1/time_off/whos_out/' -UseBasicParsing -Method GET -Headers $headers
    $jsonObject = $response | ConvertFrom-Json
    
    return $jsonObject
}

function ParseDateMessage{
    param(
        [String]$dateString
    )

    $dateTime = [datetime]::ParseExact($dateString, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
    $formattedDate = $dateTime.ToString("dddd, MMMM dd' 'yyyy")
    $formattedDate = $formattedDate -replace '(?<=\d)(st|nd|rd|th)','$0 '
    
    return $formattedDate
}
function ParseDateOutlook {
    param(
        [String]$dateString
    )

    $dateTime = [datetime]::ParseExact($dateString, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
    $formattedDate = $dateTime.ToString("MM/dd/yyyy")
    
    return $formattedDate
}

function SetOutOfOffice{
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserEmail,

        [Parameter(Mandatory = $true)]
        [string]$ExternalMessage,

        [Parameter(Mandatory = $true)]
        [DateTime]$StartTime,

        [Parameter(Mandatory = $true)]
        [DateTime]$EndTime
    )

    # Set Out of Office configuration
    Set-MailboxAutoReplyConfiguration -Identity $UserEmail -AutoReplyState Scheduled -StartTime $StartTime -EndTime $EndTime -ExternalMessage $ExternalMessage

}

function GetEmail{
    param(
        [String]$EmployeeName
    )
    $headers=@{}
    $authentication_api = API_KEY
    $headers.Add("Accept", "application/json")
    $headers.Add("authorization", "Basic $authentication_api")
    $response = Invoke-WebRequest -Uri 'https://api.bamboohr.com/api/gateway.php/seafirstinsurance/v1/employees/directory' -UseBasicParsing -Method GET -Headers $headers
    $jsonObject = $response | ConvertFrom-Json
    $matchedEmployee = $jsonObject.employees | Where-Object { $_.displayName -eq $employeeName }
    
    return $matchedEmployee.workEmail

}
function Main{


    # Connect to Exchange Online and set a session
    $session = Connect-ExchangeOnline -CertificateThumbPrint $AZURETHUMBPRINT -AppID $APP_ID -Organization $ORGANIZATION
    
    $TimeOffObject = APIGetDataBambooHR

    foreach($user in $TimeOffObject){

        $Name = $user.name
        $UserEmail = GetEmail -EmployeeName $Name

        $StartTime = $user.start
        $StartOutlookFormat = ParseDateOutlook -dateString $StartTime
        $StartMessageFormat = ParseDateMessage -dateString $StartTime
        
        $EndTime = $user.end
        $EndOutlookFormat = ParseDateOutlook -dateString $EndTime
        $EndMessageFormat = ParseDateMessage -dateString $EndTime
        $FinalEndOutlookFormat = $EndOutlookFormat + " 11:59PM"

        Write-Output " "
        Write-Output "Updating user: $Name (${UserEmail})"
        Write-Output "Timeoff Start: $StartOutlookFormat"
        Write-Output "Timeoff End: $FinalEndOutlookFormat"
        Write-Output " "
        $ExternalMessage = "Thank you for your message. I am out of the office with no access to email from ${StartMessageFormat}, until ${EndMessageFormat}. I will respond to your email as soon as possible upon my return."
        Write-Output $ExternalMessage
        Write-Output " "
        SetOutOfOffice -UserEmail $UserEmail -ExternalMessage $ExternalMessage -StartTime $StartOutlookFormat -EndTime $FinalEndOutlookFormat
        Write-Output " "
        Write-Output "===================================="
        Start-Sleep -Seconds 1
    }

    # Disconnect the session
    Disconnect-ExchangeOnline -Confirm:$false


}
Main