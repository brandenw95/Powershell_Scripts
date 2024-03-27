## Applied Epic Browser Desktop Icon Creator

### Description
This script checks if the Applied Epic Browser is installed and if its desktop icon exists. If not, it creates a desktop icon for the Applied Epic Browser. The script also copies an icon file (`EpicBrowser.ico`) to the system and sets it as the icon for the shortcut.

### Usage
1. Ensure PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `CreateEpicIcon.ps1`.
3. Place the `EpicBrowser.ico` icon file in the same directory as the script.
4. Open PowerShell as an administrator.
5. Navigate to the directory where the script is located using the `cd` command.
6. Execute the script by typing `.\CreateEpicIcon.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Checking for file existence using `Test-Path`: O(1)
- Copying files using `Copy-Item`: O(1)
- Creating a shortcut using `New-Object -ComObject WScript.Shell`: O(1)

Since the majority of operations have constant-time complexity, the overall time complexity of the script is O(1).

### Note
- Ensure that the `EpicBrowser.ico` icon file is placed in the same directory as the script.
- Modify the `$target`, `$startIn`, and `$shortcutPath` variables according to the installation path and desired behavior of the shortcut.
- Modifying files on the desktop may require appropriate permissions.
- Ensure you have appropriate permissions to create shortcuts and copy files to the desktop before running this script.
