#!/bin/bash
set -e

# Get execution directory (where script was run)
EXECUTION_DIR="$(pwd)"

# Default environment
ENVIRONMENT="macos"
CONFIG_MODE="global"

# Parse arguments
for arg in "$@"; do
  case $arg in
    --env=*)
      ENVIRONMENT="${arg#*=}"
      shift
      ;;
  esac
done

echo "Setting up environment: $ENVIRONMENT in $EXECUTION_DIR"

# Ensure ChezMoi is installed globally
if ! command -v chezmoi &> /dev/null; then
  echo "Installing ChezMoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

# Force the correct ChezMoi path
CHEZMOI_BIN="$HOME/.local/bin/chezmoi"

# Check that ChezMoi is available
if [ ! -x "$CHEZMOI_BIN" ]; then
  echo "ERROR: ChezMoi is not installed or not executable."
  exit 1
fi

# Extract config mode from environments.yaml
echo "DEBUG: ChezMoi data output:"
"$CHEZMOI_BIN" data
CONFIG_MODE=$("$CHEZMOI_BIN" data | jq -r ".chezmoidata.environments[\"$ENVIRONMENT\"].config")
echo "DEBUG: Extracted CONFIG_MODE is $CONFIG_MODE"

# Apply different behavior for local vs global environments
if [[ "$CONFIG_MODE" == "local" ]]; then
  echo "Initializing and applying dotfiles in: $EXECUTION_DIR (Local environment)"
  "$CHEZMOI_BIN" init --source="$EXECUTION_DIR" ViktorJT
  "$CHEZMOI_BIN" apply --source="$EXECUTION_DIR" -- --env=$ENVIRONMENT --config=$CONFIG_MODE
else
  echo "Initializing and applying dotfiles globally (System environment)"
  "$CHEZMOI_BIN" init ViktorJT
  "$CHEZMOI_BIN" apply -- --env=$ENVIRONMENT --config=$CONFIG_MODE
fi
