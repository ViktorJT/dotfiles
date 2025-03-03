#!/bin/bash
set -e

EXECUTION_DIR="$(pwd)"

# Default values
ENVIRONMENT="macos"
CONFIG_MODE="global"

for arg in "$@"; do
  case $arg in
    --env=*)
      ENVIRONMENT="${arg#*=}"
      shift
      ;;
  esac
done

echo "Setting up environment: $ENVIRONMENT"

# Ensure ChezMoi is installed
if ! command -v chezmoi &> /dev/null; then
  echo "Installing ChezMoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
  export PATH="$HOME/.local/bin:$PATH"
fi

if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  # Initialize ChezMoi with my github username, defaults to my dotfiles repo
  echo "Initializing ChezMoi..."
  chezmoi init ViktorJT
fi

# Extract config mode from environments.yaml
CONFIG_MODE=$(chezmoi data | jq -r ".chezmoidata.environments[\"$ENVIRONMENT\"].config")

# Determine whether to use PWD or default behavior based on config mode
if [[ "$CONFIG_MODE" == "local" ]]; then
  echo "Applying dotfiles inside: $EXECUTION_DIR (Local environment)"
  chezmoi apply --source="$EXECUTION_DIR" -- --env=$ENVIRONMENT --config=$CONFIG_MODE
else
  echo "Applying dotfiles globally (System environment)"
  chezmoi apply -- --env=$ENVIRONMENT --config=$CONFIG_MODE
fi
