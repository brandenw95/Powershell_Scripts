# Author: Branden Walter
# Creation Date: April 10th 2024
# ========================
# Description:  Update a User in AD via CSV directly.
#               This code uses the singular user update function
#
# Requiremnts:  CSV located in the same directory as the script called 'reports.csv'
#               Containing:
#                            |email|supervisor|
#                            |  ...|   ...    |
#                            |_____|__________|


function UpdateUser {
    param (
        [string]$Email,
        [string]$Csv,
        [String]$SamName
    )

    # Check if the CSV file exists
    if (-not (Test-Path $Csv)) {
        Write-Host "No CSV file found" -ForegroundColor Red
        exit 1
    }

    $csvData = Import-Csv -Path $Csv
    $match = $csvData | Where-Object { $_.email -eq $Email }

    if ($match) {

        Set-ADUser -Identity $SamName -Manager $match.supervisor
        Write-Host "SUCCESS" -ForegroundColor Green
    } 
    else {
        Write-Host "ERROR: Not in CSV" -ForegroundColor Yellow
    }
}

function Main{

    Write-Host "========================" -ForegroundColor Cyan
    Write-Host "User Updater" -ForegroundColor Green
    Write-Host "This script is used to update the following attributes of the user:" -ForegroundColor Yellow
    Write-Host "- Reports to / Direct Report" -ForegroundColor White
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host " "

    #Grab all users from AD
    $UserObjectArray = Get-ADUser -Filter * | Where-Object { $_.Enabled -eq $true } | Select-object GivenName,UserPrincipalName,SamAccountName
    $CsvFilePath = Join-Path -Path $PSScriptRoot -ChildPath "report.csv"
    $UpdateCounter = 0
    
    foreach($user in $UserObjectArray){
        
        $UserEmailAddress = $user.UserPrincipalName
        $UserSamName = $user.SamAccountName

        if(($SingleUserEmailAddress -ne " ") -or ($null -ne $SingleUserEmailAddress)){

            Write-Output " "
            Write-Output "Updating User: $UserEmailAddress" 
            UpdateUser -Email $UserEmailAddress -SamName $UserSamName -Csv $CsvFilePath
            $UpdateCounter++
        
        }
    }

    Write-Output " "
    Write-Output "USERS UPDATED: $UpdateCounter"
    Write-Output " "
    Write-Host "Syncing Delta with Office Admin..." -ForegroundColor Yellow
    Start-adsyncsynccycle -policytype delta
    exit 0
}
Main