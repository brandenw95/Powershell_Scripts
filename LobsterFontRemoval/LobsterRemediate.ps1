# Define the file name
$fileName = "Lobster_regular.tiff"

# Define the paths to the system and user font directories
$systemFontPath = "C:\Windows\Fonts"
$userFontBasePath = "C:\Users"

# Function to remove the file if it exists
function Remove-FileIfExists {
    param (
        [string]$path
    )

    $filePath = Join-Path -Path $path -ChildPath $fileName
    if (Test-Path -Path $filePath) {
        try {
            Remove-Item -Path $filePath -Force -ErrorAction Stop
            Write-Output "Successfully removed file: $filePath"
        } catch {
            Write-Output "Failed to remove file: $filePath. Error: $_"
        }
    } else {
        Write-Output "File not found: $filePath"
    }
}

# Remove the file from the system font directory
Remove-FileIfExists -path $systemFontPath

# Remove the file from all user font directories
$userProfiles = Get-ChildItem -Path $userFontBasePath -Directory
foreach ($profile in $userProfiles) {
    $userFontPath = Join-Path -Path $profile.FullName -ChildPath "AppData\Local\Microsoft\Windows\Fonts"
    Remove-FileIfExists -path $userFontPath
}
