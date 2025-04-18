#!/bin/bash

echo "🔍 Check if Remote Assistant Custom Component needs to be updated..."

TARGET_DIR="/config/custom_components/remote_assistant"
MANIFEST_FILE="$TARGET_DIR/manifest.json"

# Check if installed
if [ ! -f "$MANIFEST_FILE" ]; then
    echo "⚠️ No existing installation found. Update is skipped."
    exit 1
fi

# Get installed local version from manifest
local_version=$(grep '"version"' "$MANIFEST_FILE" | sed -E 's/.*"version": "(.*)".*/\1/')
echo "📦 Installed version: $local_version"

# Get GitHub version
github_version=$(curl -s https://api.github.com/repos/Looking4Cache/home-assistant-remote-assistant/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
echo "🌐 GitHub version: $github_version"

# Compare versions
if [ "$local_version" == "$github_version" ]; then
    echo "✅ Remote Assistant already is up to date."
    exit 0
fi

echo "⬆️ Update to version $github_version will be performed..."

# Download, extract, move
rm -rf /tmp/remote_assistant /tmp/remote_assistant.zip
mkdir -p /tmp/remote_assistant

ZIP_URL="https://github.com/Looking4Cache/home-assistant-remote-assistant/archive/refs/tags/${github_version}.zip"
curl -L "$ZIP_URL" -o /tmp/remote_assistant.zip
unzip -o /tmp/remote_assistant.zip -d /tmp/remote_assistant

UNZIP_DIR=$(find /tmp/remote_assistant -maxdepth 1 -type d -name "home-assistant-remote-assistant-*")
if [ -z "$UNZIP_DIR" ]; then
    echo "❌ Error: Failed to find the extracted files."
    exit 1
fi

# Remove existing installation, copy directory 
rm -rf "$TARGET_DIR"
mv "$UNZIP_DIR/custom_components/remote_assistant" "$TARGET_DIR"

if [ ! -f "$MANIFEST_FILE" ]; then
    echo "❌ Error: Installation failed."
    exit 1
fi

echo "✅ Remote Assistant Custom Component has been successfully updated to $github_version."

# Restart Home Assistant Core
/restart.sh