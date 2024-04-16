# Get the path of the script's directory
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Recursively list all files and directories under the script's directory
$items = Get-ChildItem -Path $scriptPath -Recurse | ForEach-Object {
    # Create a string that represents the item's path, relative to the script's directory
    $relativePath = $_.FullName.Substring($scriptPath.Length)
    
    # Add indentation based on the depth of the item in the directory structure
    $indentation = " " * ($relativePath.Split([IO.Path]::DirectorySeparatorChar).Count - 1)
    
    # Combine indentation with the item's name
    if ($_.PSIsContainer) {
        $indentation + "[D] " + $_.Name
    } else {
        $indentation + "[F] " + $_.Name
    }
}

# Specify the output file name and path
$outputFile = Join-Path -Path $scriptPath -ChildPath "DirectoryStructure.txt"

# Output the directory structure and file list to the specified text file
$items | Out-File -FilePath $outputFile

# Optionally, you can also display the output file path
Write-Host "Directory structure and file list saved to: $outputFile"
