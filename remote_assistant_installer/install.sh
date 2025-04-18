#!/bin/bash

echo "⬇️ Installing Remote Assistant Custom Component..."

TARGET_DIR="/config/custom_components/remote_assistant"
MANIFEST_FILE="$TARGET_DIR/manifest.json"

# Clean up maybe existing temp files
rm -rf /tmp/remote_assistant /tmp/remote_assistant.zip
mkdir -p /tmp/remote_assistant

# Get GitHub version
github_version=$(curl -s https://api.github.com/repos/Looking4Cache/home-assistant-remote-assistant/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
ZIP_URL="https://github.com/Looking4Cache/home-assistant-remote-assistant/archive/refs/tags/${github_version}.zip"

echo "📦 Current version of Remote Assistant is $github_version"
echo "📦 Downloading $ZIP_URL"

# Download, extract, move
curl -L "$ZIP_URL" -o /tmp/remote_assistant.zip
unzip -o /tmp/remote_assistant.zip -d /tmp/remote_assistant

UNZIP_DIR=$(find /tmp/remote_assistant -maxdepth 1 -type d -name "home-assistant-remote-assistant-*")
if [ -z "$UNZIP_DIR" ]; then
    echo "❌ Error: Failed to find the extracted files."
    exit 1
fi

# Remove maybe existing installation (should not), copy directory 
rm -rf "$TARGET_DIR"
mv "$UNZIP_DIR/custom_components/remote_assistant" "$TARGET_DIR"

if [ ! -f "$MANIFEST_FILE" ]; then
    echo "❌ Error: Installation failed."
    exit 1
fi

echo "✅ Remote Assistant Custom Component is installed (Version: $github_version)"

# Restart Home Assistant Core
/restart.sh