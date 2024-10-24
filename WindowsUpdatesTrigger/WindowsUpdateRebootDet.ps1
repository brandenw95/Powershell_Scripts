Import-Module PSWindowsUpdate

$updates = Get-WindowsUpdate

Write-Output $updates
if ($updates.Count -gt 0) {
    Write-Output "Updates are available."
    exit 1
} else {
    Write-Output "No updates are available."
    exit 0
}
