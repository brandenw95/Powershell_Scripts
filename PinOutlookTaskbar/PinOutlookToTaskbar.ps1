# Author: Branden Walter
# Date: January 26 2024
# ==================================================================
# Description:  Script to remove the default 
#               Taskbar Icons (Microsoft store and Windows Mail) 
#               and replace them with the following: Applied Epic, 
#               Outlook and Chrome. Also removes the "TaskView" Icon
# ==================================================================

Function Remove-DefaultTaskbarIcons {
    # Removes Microsoft Store and Windows Mail from the Taskbar

    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"

    Remove-ItemProperty -Path $path -Name "Microsoft.WindowsStore_8wekyb3d8bbwe!App"
    Remove-ItemProperty -Path $path -Name "microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail"
    
    # Refresh Taskbar
    Stop-Process -ProcessName explorer -Force
}

Function Add-TaskbarIcons {
    # Adds Applied Epic, Outlook, and Chrome to the Taskbar

    # Google Chrome
    $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    $shell = New-Object -ComObject Shell.Application
    $shell.Namespace(0).ParseName($chromePath).InvokeVerb("taskbarpin")

    # Outlook
    $outlookPath = "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"
    $shell = New-Object -ComObject Shell.Application
    $shell.Namespace(0).ParseName($outlookPath).InvokeVerb("taskbarpin")
    
    # Applied Epic
    $epicPath = "C:\ASI\ASI.TAM\ThinClient\Software\ASI.SMART.Client.Frame.exe Home"
    $shell = New-Object -ComObject Shell.Application
    $shell.Namespace(0).ParseName($epicPath).InvokeVerb("taskbarpin")

}

Function Remove-TaskViewIcon {
    # Removes the Task View icon from the Taskbar

    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $path -Name "ShowTaskViewButton" -Value 0

    # Refresh Taskbar
    Stop-Process -ProcessName explorer -Force
}

# Execute the functions
Remove-DefaultTaskbarIcons
Add-TaskbarIcons
Remove-TaskViewIcon

[Console]::Out.Flush() 
$error.clear()
Write-Host "Desktop Wallpaper has Been Changed Successfully"
exit 0 