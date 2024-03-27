## Local Admin Account Creator

### Description
This script creates a local administrator account on the workstation. It sets the username, password, full name, and description for the account. Additionally, it ensures that the account password never expires and adds the account to the Administrators group.

### Usage
1. Ensure PowerShell execution policy allows running scripts. You can change the execution policy by running PowerShell as an administrator and executing the command `Set-ExecutionPolicy RemoteSigned`.
2. Copy the script into a new file with a `.ps1` extension, e.g., `CreateLocalAdminAccount.ps1`.
3. Open PowerShell as an administrator.
4. Navigate to the directory where the script is located using the `cd` command.
5. Execute the script by typing `.\CreateLocalAdminAccount.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Creating a secure string using `ConvertTo-SecureString`: O(n) where n is the length of the password
- Creating a local user using `New-LocalUser`: O(1)
- Adding a user to a local group using `Add-LocalGroupMember`: O(1)

Since the majority of operations have constant-time complexity, the overall time complexity of the script is primarily determined by the length of the password (O(n)), where n is the number of characters in the password.

### Note
- This script creates a local administrator account. Ensure that this action complies with your organization's security policies and best practices.
- Modify the `$username` and `$password` variables with appropriate values before running the script.
- Modifying local user accounts and group membership may require appropriate permissions.
- Ensure you have appropriate permissions to perform administrative tasks before running this script.
