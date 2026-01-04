# 🎮 Citron Nightly Linux Updater/Launcher

A simple bash script to automate the installation, updating, and launching of **Citron-Nightly** x86_64 build on Linux.

## ✨ Features
* **Version Checking:** Only downloads if a newer build is detected on GitHub.
* **Automatic Backup:** Renames the previous version to `.bak` before updating.
* **Clean Install:** Installs .AppImage to `~/.citron-nightly/`.
* **Auto-Launch:** Boots the AppImage immediately after checking/updating.

## 🛠️ Installation & Usage

1. **Save the script** as `citron-launcher.sh`.
2. **Make it executable**:
   ```bash
   chmod +x citron-launcher.sh
