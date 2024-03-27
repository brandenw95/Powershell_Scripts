## Workstation Information Display

### Description
This script displays information about the workstation, including computer name, serial number, manufacturer, model number, CPU, RAM, and storage. It then writes this information to a text file.

### Usage
1. Ensure PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `WorkstationInfo.ps1`.
3. Open PowerShell as an administrator.
4. Navigate to the directory where the script is located using the `cd` command.
5. Execute the script by typing `.\WorkstationInfo.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Retrieving computer information using WMI queries: O(1)
- Creating a text file and writing to it using `Out-File`: O(1)

Since the majority of operations have constant-time complexity, the overall time complexity of the script is O(1).

### Note
- Modifying WMI queries and writing to files may require appropriate permissions.
- Ensure you have appropriate permissions to access computer information and write to files before running this script.
