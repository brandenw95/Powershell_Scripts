# Author: Branden Walter
# Date: April 16th 2024
# ========================
# Description: Script to change the default file type from edge to Adobe. The DISM fix
# ========================
function InitialChecks{

    $directoryPath = "C:\Temp"
    $dismExportPath = Join-Path -Path $directoryPath -ChildPath "FileCheck.xml"

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

    $dismExportPath = "C:\Temp\FileCheck.xml"
    Dism.exe /Online /Export-DefaultAppAssociations:$dismExportPath
    [xml]$xmlContent = Get-Content $dismExportPath
    $association = $xmlContent.DefaultAssociations.Association | Where-Object { $_.Identifier -eq ".pdf" }

    if ($association) {
        if ($association.ProgId -eq "MSEdgePDF") {
            Write-Output "Edge ProgID found for .pdf"
            exit 1
        }
        elseif ($association.ProgId -eq "Acrobat.Document.DC") {
            Write-Output "Adobe ProgID found for .pdf"
            exit 0
        }
        else {
            Write-Output "Unknown ProgID found for .pdf: $($association.ProgId)"
            exit 0
        }
    }
    }
Main
