# Author: Branden Walter
# Date: April 26th 2024
# ========================
# Description: Updates Windows
# ========================

Function WSUSUpdate {
	$Criteria = "IsInstalled=0 and Type='Software'"
	$Searcher = New-Object -ComObject Microsoft.Update.Searcher
	try {
		$SearchResult = $Searcher.Search($Criteria).Updates
		if ($SearchResult.Count -eq 0) {
			Write-Output "There are no applicable updates."
			exit
		} 
		else {
			$Session = New-Object -ComObject Microsoft.Update.Session
			$Downloader = $Session.CreateUpdateDownloader()
			$Downloader.Updates = $SearchResult
			$Downloader.Download()
			$Installer = New-Object -ComObject Microsoft.Update.Installer
			$Installer.Updates = $SearchResult
			$Result = $Installer.Install()
			Write-Output "$Result"
		}
	}
	catch {
		Write-Output "There are no applicable updates."
	}
}

WSUSUpdate
If ($Result.rebootRequired) { 
    Write-Output "Reboot Required"
    exit 0
 }