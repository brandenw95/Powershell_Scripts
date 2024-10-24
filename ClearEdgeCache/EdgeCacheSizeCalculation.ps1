# Author: Branden Walter
# Date: March 27th 2024
# ========================
# Description: Reports the cache size of edge for Intune
# ========================
function Main{
    $cachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"

    if (-Not (Test-Path -Path $cachePath)) {
        Write-Output "Cache directory not found."
        exit 0
    }
    $cacheSize = Get-ChildItem -Path $cachePath -Recurse | Measure-Object -Property Length -Sum
    
    
    $cacheSizeMB = [math]::round($cacheSize.Sum / 1MB, 2)
    
    
    if ($cacheSizeMB -gt 50) {
        Write-Output "Cache size: $cacheSizeMB MB"
        exit 1
    } else {
        Write-Output "Cache size: $cacheSizeMB MB"
        exit 0
    }
}
Main