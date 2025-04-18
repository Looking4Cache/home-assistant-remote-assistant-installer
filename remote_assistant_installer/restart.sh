#!/bin/bash

if [ "${ENABLE_RESTART_OPTIONS}" = "true" ]; then
    echo "🔄 Restarting Home Assistant Core..."
    curl -s -X POST \
        -H "Authorization: Bearer $SUPERVISOR_TOKEN" \
        -H "Content-Type: application/json" \
        http://supervisor/core/restartelse
else
    echo "🔄 Please restart Home Assistant for the changes to take effect."
fi