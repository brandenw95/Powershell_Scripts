Add-Type -Name Shell32 -Namespace Win32 -MemberDefinition @"
[DllImport("Shell32.dll")] public static extern void SHChangeNotify(int wEventId, int uFlags, IntPtr dwItem1, IntPtr dwItem2);
"@

# Author: Branden Walter
# Date: January 26 2024
# ==================================================================
# Description:  Refreshes the desktop screen without having to force restart explorer.exe
# ==================================================================

# Define the constants
$SHCNE_ASSOCCHANGED = 0x08000000
$SHCNF_FLUSH = 0x1000

# Refresh the desktop
[Win32.Shell32]::SHChangeNotify($SHCNE_ASSOCCHANGED, $SHCNF_FLUSH, [IntPtr]::Zero, [IntPtr]::Zero)
