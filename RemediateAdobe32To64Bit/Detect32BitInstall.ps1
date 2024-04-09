function main{

    $guid = "{AC76BA86-7AD7-1033-7B44-AC0F074E4100}"
    $filePath = "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRD32.exe"
    $application = Get-WmiObject -Class Win32_Product | Where-Object { $_.IdentifyingNumber -eq $guid }
    $fileExists = Test-Path $filePath

    if ($application -and $fileExists) {
        Write-Host "Application with GUID $guid exists and file path $filePath exists."
        exit 1
    } 
    else {
        Write-Host "Application with GUID $guid does not exist or file path $filePath does not exist."
        exit 0
    }
}
main