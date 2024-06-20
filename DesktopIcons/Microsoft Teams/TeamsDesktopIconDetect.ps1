
function Main {

    $IconPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\Microsoft Teams.lnk"
    $FileDirectory = "$env:USERPROFILE\AppData\Local\Microsoft\Teams\Update.exe"

    if (Test-Path $FileDirectory) {
        if(!(Test-Path $IconPath)){

            Write-Output "Installed - icon missing"
            exit 1
        }
        else{
            Write-Output "Installed- icon present"
            exit 0
        }
    }
    else{
        Write-Output "Not Installed"
        Write-Output "Install not detected in: $FileDirectory"
        exit 0
    }

}
Main