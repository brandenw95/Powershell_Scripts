$repoUrl = ""

$ScriptFileName = "Status Monitor.pyw"
$localRepoPath = "C:\temp\Scheduled Scripts\$ScriptFileName"

# Define the file to update
$scriptFile = "C:\temp\$ScriptFileName"

try {
    if (-Not (Test-Path -Path $localRepoPath)) {
        Write-Host "Cloning repository..."
        git clone $repoUrl $localRepoPath
        Write-Host "Repository cloned successfully."
    } else {
        Write-Host "Pulling latest changes from repository..."
        Set-Location $localRepoPath
        git pull
        Write-Host "Repository updated successfully."
    }
} catch {
    Write-Error "An error occurred while updating the repository: $_"
    exit 1
}

try {

    $sourceFilePath = Join-Path -Path $localRepoPath -ChildPath $ScriptFileName

    if (Test-Path -Path $sourceFilePath) {
        Write-Host "Updating $scriptFile with the latest version..."
        Copy-Item -Path $sourceFilePath -Destination $scriptFile -Force
        Write-Host "$scriptFile has been updated successfully."
    } else {
        throw "$ScriptFileName not found in the repository."
    }
} catch {
    Write-Error "An error occurred while updating the script file: $_"
    exit 1
}

