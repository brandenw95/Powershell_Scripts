# Author: Jascha Manger
# Creation Date: October 24th 2024
# ========================
# Description:  Converts the saved .nfo as a csv
#=========================

# Generate the system information report
Start-Process -FilePath "MSInfo32" -ArgumentList "/nfo c:\vsatemp\system_report.nfo" -Wait
 
# Define the path to the XML file and the output CSV file
$xmlFilePath = "C:\vsatemp\system_report.nfo"
$csvFilePath = "C:\vsatemp\windows_error_reporting.csv"
 
# Load the XML file
[xml]$xmlData = Get-Content -Path $xmlFilePath
 
# Create an array to hold the error report entries
$errorReports = @()
 
# Iterate over each <Category> to find the "Windows Error Reporting" entries
foreach ($category in $xmlData.SelectNodes("//Category[@name='Windows Error Reporting']")) {
    foreach ($data in $category.SelectNodes("Data")) {
        $time = $data.Time.InnerText
        $type = $data.Type.InnerText
        $details = $data.Details.InnerText -replace '\n', ' ' -replace '\r', ' '  # Clean up newlines in details
 
        # Create a PSObject for each entry
        $errorReport = [PSCustomObject]@{
            Time    = $time
            Type    = $type
            Details = $details
        }
 
        # Add the error report entry to the array
        $errorReports += $errorReport
    }
}
 
# Export the error reports to a CSV file
$errorReports | Export-Csv -Path $csvFilePath -NoTypeInformation -Encoding UTF8
 
Write-Host "Data has been written to '$csvFilePath'"