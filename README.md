# Citron Nightly Updater

A lightweight bash script to automate the installation, updating, and launching of Citron AppImages.

## Features
* **Version Checking:** Only downloads if a newer build is detected on GitHub.
* **Automatic Backup:** Renames the previous version to `.bak` before updating.
* **Terminal Logs:** Launches Citron with visible terminal output for debugging.
* **Organized:** Installs everything to `~/.citron-nightly/`.

## Installation & Usage

1. **Save the script** as `citron-launcher.sh`.
2. **Make it executable**:
   ```bash
   chmod +x citron-launcher.sh
