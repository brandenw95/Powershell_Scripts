## Background Personalization Script

### Description

This script allows the user to change the background manually by modifying registry keys and creating a scheduled task to run a PowerShell script at login.

### Usage

1. Ensure PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `AllowBackgroundPersonalization.ps1`.
3. Open PowerShell as an administrator.
4. Navigate to the directory where the script is located using the `cd` command.
5. Execute the script by typing `.\AllowBackgroundPersonalization.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Retrieving values from the registry using `Get-ItemProperty`.
- Removing registry keys using `Remove-ItemProperty`.
- Creating a directory using `New-Item`.
- Saving a script file using `Out-File`.
- Creating a scheduled task using `Register-ScheduledTask`.

The overall time complexity of the script can be approximated as follows:

- Retrieving values from the registry: O(1)
- Removing registry keys: O(1)
- Creating a directory: O(1)
- Saving a script file: O(n) where n is the length of the script
- Creating a scheduled task: O(1)

Since the majority of operations have constant-time complexity, the overall time complexity of the script is primarily determined by the length of the script file (O(n)), where n is the number of characters in the script.

### Note
- Modifying the Windows registry and creating scheduled tasks can have system-wide effects and should be done with caution. Ensure you understand the implications before running this script.
- This script assumes the default settings for the background personalization path in the registry. Modify the script accordingly if necessary.
