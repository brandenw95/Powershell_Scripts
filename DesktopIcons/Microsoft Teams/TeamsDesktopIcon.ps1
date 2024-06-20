function Main {

    $target = "C:\Users\Public\Desktop\Microsoft Teams.lnk"
    $startIn = "$env:USERPROFILE\AppData\Local\Microsoft\Teams\Update.exe"
    $shortcutPath = "$([System.Environment]::GetFolderPath('CommonDesktopDirectory'))\Microsoft Teams.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $target
    $shortcut.Arguments = ""
    $shortcut.WorkingDirectory = $startIn
    $shortcut.Save()
    Write-Output "Microsoft Teams shortcut created on Desktop"
    exit 0

}
Main