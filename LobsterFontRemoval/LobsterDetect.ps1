# Function to check if the file exists
function Check-FileExists {
    param (
        [string]$path,
        [string]$filename
    )

    $filePath = Join-Path -Path $path -ChildPath $filename
    if (Test-Path -Path $filePath) {
        return $true
    } else {
        return $false
    }
}

function Main {
    $fileName = "Lobster-Regular.ttf"
    $systemFontPath = "C:\Windows\Fonts"
    $userFontBasePath = "C:\Users"
    $fileFound = $false

    # Check the system font directory
    Write-Output "Checking system font directory..."
    if (Check-FileExists -path $systemFontPath -filename $fileName) {
        Write-Output "File found in system font directory."
        $fileFound = $true
    } else {
        Write-Output "File not found in system font directory."
    }

    # Check all user font directories
    Write-Output "Checking user font directories..."
    $userProfiles = Get-ChildItem -Path $userFontBasePath -Directory
    foreach ($profile in $userProfiles) {
        $userFontPath = Join-Path -Path $profile.FullName -ChildPath "AppData\Local\Microsoft\Windows\Fonts"
        if (Check-FileExists -path $userFontPath -filename $fileName) {
            Write-Output "File found in user font directory: $userFontPath"
            $fileFound = $true
        } else {
            Write-Output "File not found in user font directory: $userFontPath"
        }
    }

    if ($fileFound) {
        exit 1
    } else {
        exit 0
    }
}

Main
