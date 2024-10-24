function Create-Shortcut {
    param (
        [string]$TargetPath,
        [string]$ShortcutPath
    )

    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.Save()
}

function Main{
    # Replace the following paths with the appropriate ones for your system
    $OutlookPath = "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
    $OutlookShortcutPath = "C:\Users\$env:USERNAME\Desktop\Outlook.lnk"

    # Create a shortcut for Outlook
    Create-Shortcut -TargetPath $OutlookPath -ShortcutPath $OutlookShortcutPath

    # Pin Outlook shortcut to the taskbar
    $shell = New-Object -ComObject Shell.Application
    $taskbarPath = [System.IO.Path]::Combine([Environment]::GetFolderPath('ApplicationData'), 'Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar')

    $OutlookShortcut = $shell.Namespace($OutlookShortcutPath)
    $OutlookShortcutItem = $OutlookShortcut.ParseName((Get-Item $OutlookShortcutPath).Name)
    $OutlookShortcutItem.InvokeVerb('pintotaskbar')

}
Main