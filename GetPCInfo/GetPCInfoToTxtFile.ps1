# Author: Branden Walter
# Date: January 29th 2024
# ========================
# Description: Displays the worstation's information and writes it to a text file.
# ========================

# Get computer information
$computerName = $env:COMPUTERNAME
$serialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber
$manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
$modelNumber = (Get-WmiObject -Class Win32_ComputerSystem).Model
$cpuInfo = (Get-WmiObject -Class Win32_Processor).Name
$ramInfo = (Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB
$storageInfo = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace

# Create filename from serial number
$filename = "$($serialNumber).txt"

# Create text file with computer information
$output = "###`r`n"
$output += "Computer Name: $computerName`r`n"
$output += "Serial Number: $serialNumber`r`n"
$output += "Manufacturer: $manufacturer`r`n"
$output += "Model Number: $modelNumber`r`n"
$output += "CPU: $cpuInfo`r`n"
$output += "RAM: $($ramInfo -f 2) GB`r`n"
$output += "Storage: $($storageInfo.Size / 1GB -f 2) GB total, $($storageInfo.FreeSpace / 1GB -f 2) GB free`r`n"
$output += "###"

# Write to STDOUT
Write-Host $output

# Write to the text file
$output | Out-File -FilePath $filename

Write-Host "Computer information has been saved to $filename"
exit 0