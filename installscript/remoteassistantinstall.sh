#!/bin/bash

# --- Logging Helpers (leicht umbenannt) ---
log_info() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}

log_warn() {
  echo -e "\033[1;33m[WARN]\033[0m $1"
}

log_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
}

# --- Requirement Check ---
require_cmd() {
  if ! command -v "$1" &>/dev/null; then
    log_error "❌ Missing required command: $1"
    exit 1
  fi
}

check_requirements() {
  require_cmd curl
  require_cmd unzip
}

# --- Home Assistant Path Detection ---
get_ha_path() {
  local -a paths=(
    "$PWD"
    "$PWD/config"
    "/config"
    "/homeassistant"
    "$HOME/.homeassistant"
    "/usr/share/hassio/homeassistant"
  )
  for path in "${paths[@]}"; do
    if [ -f "$path/.HA_VERSION" ]; then
      echo "$path"
      return 0 
    fi
  done
  return 1
}

# --- Fetch Latest Release Tag from GitHub ---
fetch_github_version() {
  curl -s https://api.github.com/repos/Looking4Cache/home-assistant-remote-assistant/releases/latest | grep '"tag_name":' | cut -d '"' -f 4
}

# --- Install or Update Component ---
install_or_update() {
  local ha_path="$1"
  local TARGET_DIR="$ha_path/custom_components/remote_assistant"
  local MANIFEST_FILE="$TARGET_DIR/manifest.json"

  # Get current version from GitHub
  local github_version=$(fetch_github_version)
  if [[ -z "$github_version" ]]; then
    log_error "❌ Failed to retrieve latest version from GitHub."
    exit 1
  fi
  log_info "Latest version: $github_version"

  # Check existing version
  if [[ -f "$MANIFEST_FILE" ]]; then
    current_version=$(grep '"version":' "$MANIFEST_FILE" | sed -E 's/.*"([^"]+)".*/\1/')
    log_info "Installed version: $current_version"
    if [[ "$current_version" == "$github_version" ]]; then
      log_info "✅ Remote Assistant is already up-to-date."
      return
    else
      log_info "Updating Remote Assistant from $current_version to $github_version..."
    fi
  else
    log_info "Installing Remote Assistant..."
  fi

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
  mv "$UNZIP_DIR" "$TARGET_DIR"
  rm -rf "$TARGET_DIR/.github"
  rm "$TARGET_DIR/.gitignore"

  if [ ! -f "$MANIFEST_FILE" ]; then
    echo "❌ Error: Installation failed."
    exit 1
  fi

  log_info "Remote Assistant $github_version has been installed to $TARGET_DIR"

  # Cleanup
  rm -rf /tmp/remote_assistant /tmp/remote_assistant.zip

  # Restart Home Assistant info
  log_warn "🔄 Please restart Home Assistant for the changes to take effect."
}

# --- Main Execution ---
check_requirements
ha_path=$(get_ha_path)
if [ -z "$ha_path" ]; then
    log_error "❌ Could not detect your Home Assistant config directory. Please run this script inside your config directory." >&2
else
    log_info "Detected Home Assistant config path: $ha_path"
    install_or_update "$ha_path"
fi
