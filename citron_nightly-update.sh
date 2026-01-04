#!/bin/bash

# --- Configuration ---
REPO="Zephyron-Dev/Citron-CI"
TAG="nightly-linux"
INSTALL_DIR="$HOME/.citron-nightly"
API_URL="https://api.github.com/repos/$REPO/releases/tags/$TAG"

# --- Color Definitions ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color (Reset)

# --- Functions for Logging ---
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WAIT]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Ensure the directory exists
mkdir -p "$INSTALL_DIR"

info "Checking for Citron Nightly updates..."

# 1. Fetch release data from GitHub API
RELEASE_DATA=$(curl -s "$API_URL")
DOWNLOAD_URL=$(echo "$RELEASE_DATA" | grep -oP '"browser_download_url":\s*"\K[^"]*x86_64[^"]*\.AppImage' | head -n 1)
REMOTE_DATE_STR=$(echo "$RELEASE_DATA" | grep -oP '"published_at":\s*"\K[^"]*')
# Extract the actual filename from the URL
FILE_NAME=$(basename "$DOWNLOAD_URL")
FULL_PATH="$INSTALL_DIR/$FILE_NAME"

if [ -z "$DOWNLOAD_URL" ]; then
    error "Could not find x86_64 AppImage on the release page."
    exit 1
fi

# 2. Version/Update Checker
UP_TO_DATE=false
if [ -f "$FULL_PATH" ]; then
    REMOTE_TIME=$(date -d "$REMOTE_DATE_STR" +%s)
    LOCAL_TIME=$(stat -c %Y "$FULL_PATH")

    if [ "$LOCAL_TIME" -ge "$REMOTE_TIME" ]; then
        UP_TO_DATE=true
    fi
fi

if [ "$UP_TO_DATE" = true ]; then
    success "Citron is already up to date ($FILE_NAME). Skipping download."
else
    warn "New version detected: $FILE_NAME"
    
    # Backup logic: Rename current file to .bak before downloading new one
    if [ -f "$FULL_PATH" ]; then
        info "Creating backup of current version..."
        mv "$FULL_PATH" "${FULL_PATH}.bak"
    fi

    warn "Downloading..."
    if curl -L "$DOWNLOAD_URL" -o "$FULL_PATH"; then
        chmod +x "$FULL_PATH"
        success "Update complete."
    else
        error "Download failed. Restoring backup..."
        [ -f "${FULL_PATH}.bak" ] && mv "${FULL_PATH}.bak" "$FULL_PATH"
        exit 1
    fi
fi

# 3. Launch AppImage
info "Launching $FILE_NAME (Terminal output below)"
echo -e "${YELLOW}------------------------------------------------${NC}"
"$FULL_PATH"
