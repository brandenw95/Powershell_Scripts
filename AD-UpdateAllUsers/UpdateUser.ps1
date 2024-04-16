# Author: Branden Walter
# Creation Date: April 5th 2024
# ========================
# Description:  Update a User in AD via the API in BambooHR directly.
#               This code uses the singular user update function for
#               the bulk update too so it is more modular and efficient.
#
# Exit Codes:
#               0 - Success - Indicates successful completion of the operation.
#               1 - Incorrect Usage - Indicates incorrect usage or invalid parameters.
#               2 - Active Directory Code Failed - Indicates failure in Active Directory-related operations and commands.
#               3 - Invalid Parameter - Indicates invalid parameters provided to the script.
#
# Function Hierarchy:
#
#         Function Main {
#                 Description: Main entry point of the script.
#                 Calls: singleUpdate, bulkUpdate
#         }
#
#         Function singleUpdate {
#                 Description: Updates a single user record in Active Directory via the BambooHR API.
#                 Parameters:
#                         - userEmail: Specifies the email of the user whose record needs to be updated.
#                         - bulkUpdate: Specifies whether the update is being performed for a single user or for bulk updates. Default value is "False".
#                         - debug: Specifies whether the script is run in debug mode. Default value is "False".
#                 Calls: None
#         }
#
#         Function bulkUpdate {
#                 Description: Updates all users in Active Directory via the BambooHR API.
#                 Parameters:
#                         - debug: Specifies whether the script is run in debug mode. Default value is "False".
#                 Calls: singleUpdate
#         }
#
# ========================

<#
    .SYNOPSIS
    SeaFirst Insurance User Updater

    .DESCRIPTION
    This script is used to update various attributes of user records in the SeaFirst Insurance Active Directory, including Department, Job Title, Work Phone number, and Reports to.

    .PARAMETER userEmail
    Specifies the email of the user whose record needs to be updated.

    .PARAMETER bulkUpdate
    Specifies whether the update is being performed for a single user or for bulk updates. Default value is "False".

    .PARAMETER debug
    Specifies whether the script is run in debug mode. If set to "True", no changes will be made to Active Directory, only local testing will be performed. Default value is "False".

    .NOTES
    !!!IMPORTANT - Please Update version number below with every modification!!!
    ==============================
    Version: 1.1
    Author: Branden Walter
    Date: April 1st 2024
    Modification Notes:
    - Refactored code to include a bulk update feature.
    ==============================
    Version:
    Author:
    Modification Notes:
    - *Insert your notes here*
    ==============================    
#>

function singleUpdate{
    param(
        [string]$userEmail,
        [string]$bulkUpdate = "False",
        [string]$debug = "False"
    )

    # If an email is given in the parameter then it is used for updating in bulk
    if (-not $userEmail) {
        $userEmail = Read-Host "Please enter the email of the user (ex. dhill@seafirstinsurance.com)"
    }
    
    # Authenticate, Query the API and return entire directory and report to.
    $headers=@{}
    $authentication_api = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("1234:x"))
    $headers.Add("Accept", "application/json")
    $headers.Add("authorization", "Basic $authentication_api")
    $response = Invoke-WebRequest -Uri 'https://api.bamboohr.com/api/gateway.php/seafirstinsurance/v1/employees/directory' -UseBasicParsing -Method GET -Headers $headers
    $jsonObject = $response | ConvertFrom-Json
    # Find the User we are looking for in the directry by email.
    $matchedEmployee = $jsonObject.employees | Where-Object { $_.workEmail -eq $userEmail }

    # Grab the supervisor name and format accordingly (LastName, FirstName -> FirstName LastName) via employee id
    $employeeid = $matchedEmployee.id
    $apiUri = "https://api.bamboohr.com/api/gateway.php/seafirstinsurance/v1/employees/" + $employeeid + "/?fields=supervisor&onlyCurrent=true"
    $nameJson = Invoke-WebRequest -Uri $apiUri -UseBasicParsing -Method GET -Headers $headers
    $nameObject = $nameJson | ConvertFrom-Json
    $name = $nameObject.supervisor
    
    # Format the string
    $components = $name -split ", "
    $firstname = $components[1]
    $lastname = $components[0]
    # Check if the last name has white space characters, if so
    # Split and take the last name of the multiple names.
    if($lastname -match "\s"){
        $lastNameSplit = $lastname -split " "
        $lastname = $lastNameSplit[-1] 
    }
    $supervisorName = "$firstname $lastname - SeaFirst Insurance"
    $supervisorFirstInitial = $firstname[0]
    $supervisorSam = "$supervisorFirstInitial$lastname"
    $supervisorSam = $supervisorSam.ToLower()
    
    if ($matchedEmployee) {

        # Parse and Initialize the variables
        $firstName = $matchedEmployee.firstName
        $lastName = $matchedEmployee.lastName
        $jobTitle = $matchedEmployee.jobTitle
        $workPhone = $matchedEmployee.workPhone
        $department = $matchedEmployee.department
        $email = $matchedEmployee.workEmail
        $company = "SeaFirst Insurance"

        #Parse the email to get the username to be used to match with AD user
        $userSamNameInBamboo = $email.Split("@")[0]

        if($bulkUpdate -eq "False"){
            # Output the information
            Write-Output " "
            Write-Output "Information queried from BambooHR on user $firstName $lastName"
            Write-Output "==============================="
            Write-Output "Name: $firstName $lastName"
            Write-Output "Username: $userSamNameInBamboo"
            Write-Output "Job Title: $jobTitle"
            Write-Output "Work Phone: $workPhone"
            Write-Output "Department: $department"
            Write-Output "Email: $email"
            Write-output "Company: $company"
            Write-output "Reports To: $supervisorName"
            Write-Output "==============================="
            Write-Output " "
            $responseConfirmation = Read-Host "Is this info correct? [Y/N]"
            Clear-Host
        }
        else{
            # Bypass confirmation if bulk updating
            $responseConfirmation = "Y"
        }
        
        if($responseConfirmation -eq "Y"){
            
            if($debug -eq "False"){

                #Write-Host "Checking to see if User or Manager is valid in Active Directory... " -ForegroundColor Yellow -NoNewline
                
                # Determine if user AND Manager exists in Active Directory
                $ValidActiveDirectoryUser = Get-ADUser -Filter {SamAccountName -eq $userSamNameInBamboo}
                $ValidActiveDirectoryManager = Get-ADUser -Filter {SamAccountName -eq $supervisorSam}

                if($null -eq $ValidActiveDirectoryUser -or $null -eq $ValidActiveDirectoryManager){

                    Write-Host "User or Manager does not exist in Active Directory" -ForegroundColor Red
                    Write-Output "User: $ValidActiveDirectoryUser"
                    Write-Output "Manager: $ValidActiveDirectoryManager"
                    
                }
                else{
                   

                    
                    if($null -eq $ValidActiveDirectoryManager){
                    Set-ADUser -Identity $userSamNameInBamboo -Title $jobTitle -OfficePhone $workPhone -Company $company -Department $department -WhatIf
                    }
                    
                    
                    Write-Output " "
                    Write-Output "==============================="
                    Write-Host "Updating $firstName $lastName..." -ForegroundColor Yellow
                    Write-Output "Job Title: $jobTitle"
                    Write-Output "Work Phone: $workPhone"
                    Write-Output "Department: $department"
                    Write-Output "Email: $email"
                    Write-Output "Company: $company"
                    Write-Output "Reports To: $supervisorName"
                    Write-Host "Status: " -NoNewline
                    Write-Host "SUCCESS" -ForegroundColor Green
                    Write-Output "==============================="
                    #Set User in AD
                    Set-ADUser -Identity $userSamNameInBamboo -Title $jobTitle -Manager $supervisorSam -OfficePhone $workPhone -Company $company -Department $department -WhatIf
                }
            }
            else{
                
                Write-Output " "
                Write-Output "==============================="
                Write-Host "Updating $firstName $lastName..." -ForegroundColor Yellow
                Write-Output "Job Title: $jobTitle"
                Write-Output "Work Phone: $workPhone"
                Write-Output "Department: $department"
                Write-Output "Email: $email"
                Write-Output "Company: $company"
                Write-Output "Reports To: $supervisorName"
                Write-Host "Status: " -NoNewline
                Write-Host "SUCCESS" -ForegroundColor Green
                Write-Output "==============================="
            }

            if($bulkUpdate -eq "False" -and $debug -eq "False"){

                Write-Host " "
                Write-Host "Syncing Delta with Office Admin..." -ForegroundColor Yellow
                Start-adsyncsynccycle -policytype delta
                Write-Host " "
                exit 0
            }
        }
        if($responseConfirmation -eq "N"){

            Write-Host " "
            Write-Host "User aborted AD User Update - No modifications made" -ForegroundColor Red
            Write-Host " "
            exit 0
        }
    }
    else{
        Write-Output "No user found with the email $userEmail"
        #exit 1
    }
}

function bulkUpdate{
    param(
        [string]$debug = "False"
    )

    if($debug -eq "False"){

        # Get Active Directory Users
        $Users = Get-ADUser -Filter * | Where-Object { $_.Enabled -eq $true } | Select-object GivenName,UserPrincipalName

        $UpdateCounter = 0

        #Loop through all users and further filter down
        foreach($user in $Users){
            
            $SingleUserEmailAddress = $user.UserPrincipalName
            $SingleUserGivenName = $user.GivenName

            #Filters out all users with blank emails and emails that dont have a valid '@seafirstinsurance.com' domain
            if(($SingleUserEmailAddress -ne " ") -and ($SingleUserEmailAddress -match "@seafirstinsurance.com")){

                if($SingleUserGivenName -notin "Jody", "Douglas", "Doug", "Ana", "Randi", "Jaime"){
                    #Display all emails in a list
                    singleUpdate -userEmail $SingleUserEmailAddress -bulkUpdate "True" -debug $debug
                    $UpdateCounter++
                    Start-Sleep -Seconds 1
                }
            }
        }
        Write-Output " "
        Write-Output "USERS UPDATED: $UpdateCounter"
        Write-Output " "
        Write-Host "Syncing Delta with Office Admin..." -ForegroundColor Yellow
        Start-adsyncsynccycle -policytype delta
    }
    elseif ($debug -eq "True") {

        #Create a simple Test array with vaild emails
        $MultiUserEmailAddressArray = @("bwagar@seafirstinsurance.com", 
                                        "dhill@seafirstinsurance.com") 
        
        $DebugCounter = 0
    
        foreach ($multiUser in $MultiUserEmailAddressArray){

            singleUpdate -userEmail $multiUser -bulkUpdate "True" -debug $debug
            $DebugCounter++
            Start-Sleep -Seconds 1
        }
        Write-Output " "
        Write-Output "USERS UPDATED: $DebugCounter"
        Write-Output " "
        Write-Host "Syncing Delta with Office Admin..." -ForegroundColor Yellow
        Write-Host "Success" -ForegroundColor Green
    }
    else{
        Write-Output "Something went wrong"
        exit 3
    }
}

function Main {
    
    $DEBUG = "False"
    # If $DEBUG = "True": No Active directory code is excecuted, used to test the code, API call locally and create a log of output.
    # If $DEBUG = "False": Active directory changes can be made and synced with Microsoft 365.

    if($DEBUG -eq "True") {
        #Start the log file in the same directory as the script.
        $transcriptPath = Join-Path -Path $PSScriptRoot -ChildPath "NewADUserScriptLogFile.txt"
        Start-Transcript -Path $transcriptPath
    }

    Write-Host "========================" -ForegroundColor Cyan
    Write-Host "SeaFirst Insurance User Updater" -ForegroundColor Green
    Write-Host "This script is used to update the following attributes of the user:" -ForegroundColor Yellow
    Write-Host "- Department" -ForegroundColor White
    Write-Host "- Job Title" -ForegroundColor White
    Write-Host "- Work Phone number" -ForegroundColor White
    Write-Host "- Reports to" -ForegroundColor White
    Write-Host "========================" -ForegroundColor Cyan
    Write-Host " "
    Write-Host "1) Update a single record."
    Write-Host "2) Update all users in Active Directory."
    Write-Host " "
    $choice = Read-Host "Please choose an option. (1 or 2 and press enter)"
    Clear-Host
    
    switch ($choice) {

        1 {
            singleUpdate -debug $DEBUG
        }
        2 {
            bulkUpdate -debug $DEBUG
        }
        default{
            Write-Host "Invalid choice. Re-run script and please choose option 1 or 2."
        }
    }
    
    If($DEBUG -eq "True"){Stop-Transcript}
}

Main
