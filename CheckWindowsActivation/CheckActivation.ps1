# Author: Branden Walter
# Date: March 27th 2024
# ========================
# Description: Checks activation of windows devices.
# ========================

function Main{
    
    $outputFile = "C:\temp\slmgr_output.txt"
    
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c slmgr /xpr > `"$outputFile`"" -Wait
    $output = Get-Content -Path $outputFile
    Write-Output "The output is:"
    Write-Output $output
    
    Remove-Item -Path $outputFile
}
Main