## Desktop Icon Cleanup

### Description
This script removes specified .lnk (shortcut) files from user and public desktops. It provides a list of filenames to delete and iterates through both user and public desktops to remove the specified files.

### Usage
1. Ensure PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `RemoveLnkFiles.ps1`.
3. Open PowerShell as an administrator.
4. Navigate to the directory where the script is located using the `cd` command.
5. Execute the script by typing `.\RemoveLnkFiles.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Checking for file existence using `Test-Path`: O(1)
- Removing files using `Remove-Item`: O(1)

Since the script iterates through a fixed number of files and performs constant-time operations on each file, the overall time complexity is O(n), where n is the number of files to delete.

### Note
- Ensure that the list `$filesToDelete` contains the filenames of the .lnk files you want to remove from both user and public desktops.
- Modifying files on the desktop may require appropriate permissions.
- Ensure you have appropriate permissions to delete files from user and public desktops before running this script.
