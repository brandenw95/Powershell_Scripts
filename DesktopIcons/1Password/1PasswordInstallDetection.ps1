
function Main {

    # If the Shortcut does not exist on the desktop create or it is not installed 
    $IconPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\1Password.lnk"
    $FileDirectory = "C:\Program Files\1Password"

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
        exit 0
    }

}
Main