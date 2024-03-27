## Wallpaper and Lockscreen Setter


### Description
This script automates the process of downloading wallpaper and lockscreen images from specified URLs and sets them on the workstation. It also updates the registry settings to reflect the changes in wallpaper and lockscreen.

### Usage
1. Copy the script into a new file with a `.ps1` extension, e.g., `SetWallpaper.ps1`.
2. Open PowerShell as an administrator.
3. Navigate to the directory where the script is located using the `cd` command.
4. Execute the script by typing `.\SetWallpaper.ps1` and pressing Enter.

### Runtime Analysis

The runtime complexity of this script mainly depends on the following operations:

- Downloading images using `Start-BitsTransfer`: O(1)
- Modifying registry settings using `New-ItemProperty` and `Set-ItemProperty`: O(1)

Since the majority of operations have constant-time complexity, the overall time complexity of the script is O(1).

### Note
- Modify the `$WallpaperURL`, `$LockscreenUrl`, and `$ImageDestinationFolder` variables to specify the URLs from which to download images and the destination folder where images will be stored.
- Ensure you have appropriate permissions to download files and modify registry settings.
