# Author: Branden Walter
# Date: April 16th 2024
# ========================
# Description: Script to chnage the default file type from edge to Adobe. The DISM fix
# ========================
function InitialChecks{

    $directoryPath = "C:\Temp"
    $dismExportPath = Join-Path -Path $directoryPath -ChildPath "app.xml"

    # Check if the directory exists, if not create it
    if (-not (Test-Path -Path $directoryPath)) {
        New-Item -Path $directoryPath -ItemType Directory
    }

    # Check if the file already exists, if it does, remove it
    if (Test-Path -Path $dismExportPath) {
        Remove-Item -Path $dismExportPath -Force
}
}
function Main{

    InitialChecks
    $xmlPath = "C:\Temp\app.xml"
    Dism /Online /Export-DefaultAppAssociations:$xmlPath
    [xml]$xmlContent = Get-Content $xmlPath

    $association = $xmlContent.DefaultAssociations.Association | Where-Object { $_.Identifier -eq ".pdf" -and $_.ProgId -eq "MSEdgePDF" }

    if ($association) {

        $association.ProgId = "Acrobat.Document.DC"
        $association.ApplicationName = "Adobe Acrobat"
        $xmlContent.Save($xmlPath)
        Dism.exe /Online /Import-DefaultAppAssociations:$xmlPath

        # Restart explorer.exe
        #Stop-Process -Name explorer -Force
        #Start-Process explorer

        Write-Output "Successfully changed the File accociation for pdf"
        exit 0
    } 
    else {
        Write-Output "PDF Already Default"
        exit 0
    }

}
Main

