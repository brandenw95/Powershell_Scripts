## Adobe Reader Association Changer

This PowerShell script checks if Adobe Reader is installed on the system and changes the default file association for PDF files to Adobe Reader if it's found. If Adobe Reader is not installed, it notifies the user.

### Prerequisites

- This script requires PowerShell to be installed on the system.
- Adobe Reader needs to be installed at the default installation path: `C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe`.

### Usage

1. Ensure that PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `ChangeAdobeAssoc.ps1`.
3. Open PowerShell as an administrator.
4. Navigate to the directory where the script is located using `cd` command.
5. Execute the script by typing `.\ChangeAdobeAssoc.ps1` and pressing Enter.

### Code Explanation

The script first checks if Adobe Reader is installed by verifying the presence of the executable file. If Adobe Reader is found, it sets the necessary variables such as the path to the Adobe Reader executable and the file extension. It then uses the New-Object cmdlet to create a COM object for WScript.Shell to modify the Windows registry keys associated with file extensions. The default file association for PDF files is changed to Adobe Reader. If Adobe Reader is not found, it notifies the user accordingly.

### Runtime Analysis

The runtime complexity of this script is primarily determined by the execution time of the Test-Path cmdlet, which checks for the presence of Adobe Reader executable.

- If Adobe Reader is installed, the script performs registry modifications, which typically have constant-time complexity.
- Therefore, the overall time complexity of the script is O(1) in the best-case scenario (Adobe Reader installed) and O(n) in the worst-case scenario (Adobe Reader not installed), where n is the number of files and folders checked by Test-Path.

