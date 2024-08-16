# Author: Branden Walter
# Date: June 6th 2024
# ========================
# Description: Clears Microsft Edge's cache.
# ========================

$historyPath =  "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\History"

$cachePath =  "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
function ClearCache{
    param(
        [String]$edgePath
    )

    if (Test-Path -Path $edgePath) {
        $cachePath = Join-Path -Path $edgePath -ChildPath 'Cache'
        if (Test-Path -Path $cachePath) {
            Remove-Item -Path $cachePath -Recurse -Force
            Write-Output "Edge cache cleared."
            exit 0
        } else {
            Write-Output "No Edge cache found."
            exit 0
        }
    }
}
function Main {
    
    $appDataPath = [System.Environment]::GetFolderPath('LocalApplicationData')
    $edgePath = Join-Path -Path $appDataPath -ChildPath 'Microsoft\Edge\User Data\Default\History'
    ClearCache -edgePath $edgePath
}
Main