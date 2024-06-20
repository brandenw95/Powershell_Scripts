function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $logFile = "C:\Temp\Logs\CleanOldProfilesLog.txt"
    $logDir = Split-Path -Path $logFile

    if (-Not (Test-Path -Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory
    }
    $timestamptext = Get-Date -Format "dddd MMMM dd hh:mm tt"
    $logEntry = "${timestamptext} : ${Message}"
    Add-Content -Path $logFile -Value $logEntry
    Write-Output $Message
}
function DeleteProfiles{
    param(
        [System.Object[]]$ProfileName
    )
    # Iterate through the profile names array and remove those profiles
    foreach ($name in $profileNames) {
        Write-Log " "
        Write-Log "Deleting Profile: $name ..."
        Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.split('\')[-1] -eq $name } | Remove-CimInstance
        Write-Log " "
    }
}

function Main{

    Clear-Host
    $folderPath = "C:/Users/"
    $userProfiles = Get-ChildItem -Path $folderPath -Directory
    $profileNames = @()

    $profilesToSkip = @('wpi-admin',
                        'sfi-admin',
                        'public',
                        'administrator')

    
    $thirtyDaysAgo = (Get-Date).AddDays(-30)
    
    foreach ($profile in $userProfiles) {
        $profileName = $profile.Name

        if ($profileName -notin $profilesToSkip) {

            $downloadsPath = Join-Path -Path $profile.FullName -ChildPath "Downloads"
            $lastModified = (Get-Item -Path $profile.FullName).LastWriteTime
            
            if (Test-Path -Path $downloadsPath) {
                
                $lastModifiedDownloads = (Get-Item -Path $downloadsPath).LastWriteTime
                Write-Log "$profileName's Downloads folder last modified: $lastModified"
    
                if (($lastModified -lt $thirtyDaysAgo) -and ($lastModifiedDownloads -lt $thirtyDaysAgo)) {
                    
                    $profileNames += $profileName
                }
            }
        }
    }

    DeleteProfiles -ProfileName $profileNames

    Write-Log "All profiles older than 30 days have been successfully deleted."
    exit 0
}
Main