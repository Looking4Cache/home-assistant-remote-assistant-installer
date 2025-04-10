#!/bin/bash

echo "🚀 Starting Remote Assistant Installer Add-on..."

TARGET_DIR="/config/custom_components/remote_assistant"
MANIFEST_FILE="$TARGET_DIR/manifest.json"

# Check if custom component is already installed
if [ ! -f "$MANIFEST_FILE" ]; then
    echo "📦 No existing installation found. Installation is being performed..."
    /install.sh
else
    echo "📦 Remote Assistant Custom Component is already installed. Installation skipped. Starting update check."
    /update.sh
fi

while true; do
    # Wait for 24 hours
    echo "⏳ Next update check will be performed in 24 hours"
    sleep 86400
  
    # Execute the update script
    /update.sh
done