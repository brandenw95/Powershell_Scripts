## Policy Works Desktop Icon Checker

### Description
This script checks if Policy Works is installed and if the desktop icon exists. If Policy Works is installed and the desktop icon exists, it does nothing. If Policy Works is installed but the desktop icon is missing, it creates a new desktop icon. If Policy Works is not installed, it removes any existing desktop icon.

### Usage
1. Ensure PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `CheckPolicyWorksIcon.ps1`.
3. Open PowerShell as an administrator.
4. Navigate to the directory where the script is located using the `cd` command.
5. Execute the script by typing `.\CheckPolicyWorksIcon.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Checking for folder and file existence using `Test-Path`: O(1)
- Copying files using `Copy-Item`: O(1)
- Removing files using `Remove-Item`: O(1)

Since the majority of operations have constant-time complexity, the overall time complexity of the script is O(1).

### Note
- Modify the `$folderPath` and `$originalShortcutPath` variables if the installation path or original shortcut path for Policy Works changes.
- Modifying files on the desktop may require appropriate permissions.
- Ensure you have appropriate permissions to create or remove desktop icons before running this script.
