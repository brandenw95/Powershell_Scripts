function Main{

    # Power plan settings
    $powerSchemeGuid = (powercfg /getactivescheme).split()[3]

    # Set the display to never turn off
    powercfg /change monitor-timeout-ac 0
    powercfg /change monitor-timeout-dc 0

    # Set the sleep settings
    powercfg /change standby-timeout-ac 60
    powercfg /change standby-timeout-dc 30

    $thisComputer = Get-CimInstance Win32_OperatingSystem

    if ($thisComputer.caption -match "Windows 11") {

        # Set the taskbar alignment left
        Set-ItemProperty -Path HKCU:\software\microsoft\windows\currentversion\explorer\advanced -Name 'TaskbarAl' -Type 'DWord' -Value 0

        # Disable Copilot
        Set-ItemProperty -Path HKCU:\software\microsoft\windows\currentversion\explorer\advanced -Name 'ShowCopilotButton' -Type 'DWord' -Value 0
        
        # Disable TaskView
        Set-ItemProperty -Path HKCU:\software\microsoft\windows\currentversion\explorer\advanced -Name 'ShowTaskViewButton' -Type 'DWord' -Value 0

        # Enable Compact Mode
        Set-ItemProperty -Path HKCU:\software\microsoft\windows\currentversion\explorer\advanced -Name 'UseCompactMode' -Type 'DWord' -Value 1

        # Configure the search box
        Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name 'SearchboxTaskbarMode' -Type 'DWord' -Value 2

        # Disable widgets
        Set-ItemProperty -Path HKCU:\software\microsoft\windows\currentversion\explorer\advanced -Name 'TaskbarDa' -Type 'DWord' -Value 0

        Write-Output "Configuration Complete"
    }
    exit 0
}
Main