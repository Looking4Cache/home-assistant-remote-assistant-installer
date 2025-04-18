#!/usr/bin/env bash

CONFIG_FILE="/data/options.json"
if [[ -f "$CONFIG_FILE" ]]; then
    ENABLE_RESTART=$(jq -r '.enable_restart // false' "$CONFIG_FILE")
    if [[ "$ENABLE_RESTART" = "true" ]]; then
        echo "🔄 Restarting Home Assistant Core..."
        curl -s -X POST \
            -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
            -H "Content-Type: application/json" \
            http://supervisor/core/restartelse
    else
        echo "🔄 Please restart Home Assistant for the changes to take effect."
    fi
else
    echo "🔄 Please restart Home Assistant for the changes to take effect."
fi