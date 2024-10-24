param (
    [Parameter(Mandatory=$true)]
    [string]$UPN
)

# Function to resolve IP address to location
function Resolve-IPAddress {
    param (
        [Parameter(Mandatory=$true)]
        [string]$IPAddress
    )

    try {
        $response = Invoke-RestMethod -Uri "http://ipinfo.io/$IPAddress/json"
        return [PSCustomObject]@{
            IPAddress = $IPAddress
            City = $response.city
            Region = $response.region
            Country = $response.country
            Location = $response.loc
        }
    } catch {
        return [PSCustomObject]@{
            IPAddress = $IPAddress
            City = "Unknown"
            Region = "Unknown"
            Country = "Unknown"
            Location = "Unknown"
        }
    }
}

# Connect to Microsoft Graph
Write-Host "Connecting to Microsoft Graph..."
Connect-MgGraph -Scopes "AuditLog.Read.All", "Directory.Read.All"

# Define the date range (last 30 days)
$endDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
$startDate = (Get-Date).AddDays(-30).ToString("yyyy-MM-ddTHH:mm:ss")

# Fetch Sign-In Logs
Write-Host "Fetching Sign-In Logs..."
$signIns = Get-MgAuditLogSignIn -Filter "userPrincipalName eq '$UPN' and createdDateTime ge $startDate and createdDateTime le $endDate" -All

# Group Sign-Ins by IP and resolve location
$ipLocations = $signIns | Group-Object -Property ipAddress | ForEach-Object {
    $ip = $_.Name
    $location = Resolve-IPAddress -IPAddress $ip
    [PSCustomObject]@{
        Date = ($_.Group | Select-Object -ExpandProperty CreatedDateTime).Date
        IPAddress = $ip
        SignIns = $_.Count
        Location = "$($location.City), $($location.Region), $($location.Country)"
        GPSLocation = $location.Location
    }
}

# Output the results
$ipLocations | Format-Table -AutoSize

# Disconnect from Graph
Disconnect-MgGraph
