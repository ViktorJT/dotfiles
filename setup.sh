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
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
  export PATH="$HOME/.local/bin:$PATH"
fi

# Extract config mode from environments.yaml
echo "DEBUG: ChezMoi data output:"
chezmoi data
CONFIG_MODE=$(chezmoi data | jq -r ".chezmoidata.environments[\"$ENVIRONMENT\"].config")
echo "DEBUG: Extracted CONFIG_MODE is $CONFIG_MODE"

# Apply different behavior for local vs global environments
if [[ "$CONFIG_MODE" == "local" ]]; then
  echo "Initializing and applying dotfiles in: $EXECUTION_DIR (Local environment)"
  chezmoi init --source="$EXECUTION_DIR" ViktorJT
  chezmoi apply --source="$EXECUTION_DIR" -- --env=$ENVIRONMENT --config=$CONFIG_MODE
else
  echo "Initializing and applying dotfiles globally (System environment)"
  chezmoi init ViktorJT
  chezmoi apply -- --env=$ENVIRONMENT --config=$CONFIG_MODE
fi
