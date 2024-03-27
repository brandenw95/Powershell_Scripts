## Desktop Refresh Script

### Description
This script refreshes the desktop, updating any changes made to file associations or desktop icons.

### Usage
1. Copy the script into a new file with a `.ps1` extension, e.g., `RefreshDesktop.ps1`.
2. Open PowerShell as an administrator.
3. Navigate to the directory where the script is located using the `cd` command.
4. Execute the script by typing `.\RefreshDesktop.ps1` and pressing Enter.

### Note
- This script uses P/Invoke to call a function from `Shell32.dll` to refresh the desktop.
- Refreshing the desktop may take a moment, depending on the system's performance.
- Ensure you have appropriate permissions to execute scripts and perform desktop operations.
