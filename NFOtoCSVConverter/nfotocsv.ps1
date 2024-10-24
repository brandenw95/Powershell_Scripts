# Author(s): Jascha Mager, Branden Walter
# Creation Date: October 24th 2024
# ========================
# Description:  Converts the saved .nfo as a csv
#=========================

function CleanString($string) {

    $cleanedString = $string -replace '&#x[0-9A-Fa-f]+;', ''
    $cleanedString = $cleanedString -replace '[\x00-\x1F]', ''
    $cleanedString = $cleanedString -replace '(?i)Faulting', ''

    return $cleanedString.Trim()
}

function Main{
    
    Start-Process -FilePath "MSInfo32" -ArgumentList "/nfo system_report.nfo" -Wait

    $xmlFilePath = "system_report.nfo"
    $csvFilePath = "windows_error_reporting.csv"

    [xml]$xmlData = Get-Content -Path $xmlFilePath

    $errorReports = @()

    foreach ($category in $xmlData.SelectNodes("//Category[@name='Windows Error Reporting']")) {
        foreach ($data in $category.SelectNodes("Data")) {
            $time = $data.Time.InnerText
            $type = $data.Type.InnerText
            $details = $data.Details.InnerText -replace '\n', ' ' -replace '\r', ' '
    
    
            # REGEX Cleanup
            $faultingAppName = CleanString([regex]::Match($details, 'Faulting application name: (.+?),').Groups[1].Value)
            $appVersion = CleanString([regex]::Match($details, 'version: (.+?),').Groups[1].Value)
            $exceptionCode = CleanString([regex]::Match($details, 'Exception code: (.+?)\s').Groups[1].Value)
            $faultingModule = CleanString([regex]::Match($details, 'Faulting module name: (.+?),').Groups[1].Value)
            $faultOffset = CleanString([regex]::Match($details, 'Fault offset: (.+?)\s').Groups[1].Value)
            $faultingProcessId = CleanString([regex]::Match($details, 'Faulting process id: (.+?)\s').Groups[1].Value)
            $reportId = CleanString([regex]::Match($details, 'Report Id: (.+?)\s').Groups[1].Value)
            $packageFullName = CleanString([regex]::Match($details, 'Faulting package full name: (.+?)\s').Groups[1].Value)
    
            if (-not [string]::IsNullOrWhiteSpace($faultingAppName) -and 
                -not [string]::IsNullOrWhiteSpace($exceptionCode) -and 
                -not [string]::IsNullOrWhiteSpace($faultingProcessId)) {
    
                $errorReport = [PSCustomObject]@{
                    Time                     = $time
                    Type                     = $type
                    FaultingApplicationName   = $faultingAppName
                    ApplicationVersion        = $appVersion
                    FaultingModule            = $faultingModule
                    ExceptionCode             = $exceptionCode
                    FaultOffset               = $faultOffset
                    FaultingProcessId         = $faultingProcessId
                    ReportId                  = $reportId
                    FaultingPackageFullName   = $packageFullName
                }
    
                $errorReports += $errorReport
            }
        }
    }
    
    $errorReports | Export-Csv -Path $csvFilePath -NoTypeInformation -Encoding UTF8
    
    Write-Output "Data saved to file: '$csvFilePath'"    
}
Main