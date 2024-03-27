## Applied Epic Desktop Icon Creator

### Description
This script creates a desktop icon for Applied Epic, a software solution for insurance agencies. It creates a shortcut on the desktop that points to the Applied Epic executable file.

### Usage
1. Ensure PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `CreateAppliedEpicIcon.ps1`.
3. Open PowerShell as an administrator.
4. Navigate to the directory where the script is located using the `cd` command.
5. Execute the script by typing `.\CreateAppliedEpicIcon.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Combining paths using `[System.IO.Path]::Combine`: O(1)
- Creating a shortcut using `New-Object -ComObject WScript.Shell`: O(1)
- Setting shortcut properties: O(1)
- Saving the shortcut: O(1)
- Reading and modifying shortcut content: O(n) where n is the length of the content
- Writing shortcut content to file: O(n)

Since the majority of operations have constant-time complexity, the overall time complexity of the script is primarily determined by the length of the shortcut content (O(n)), where n is the number of characters in the content.

### Note
- This script assumes the path to the Applied Epic executable file. Modify the `targetPath` variable if the file location changes.
- Modifying files on the desktop may require appropriate permissions.
- Ensure you have appropriate permissions to create shortcuts and modify files on the desktop before running this script.
