#!/bin/bash
set -e

# Constants
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
	--config=*)
      CONFIG_MODE="${arg#*=}"
      shift
      ;;
  esac
done

echo "Setting up environment: $ENVIRONMENT"
echo "Config mode: $CONFIG_MODE"
echo "Execution directory: $EXECUTION_DIR"

# Ensure ChezMoi is installed
if ! command -v chezmoi &> /dev/null; then
  echo "Installing ChezMoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
  export PATH="$HOME/.local/bin:$PATH"
fi

# Initialize ChezMoi with your dotfiles (no need to set --source)
chezmoi init ViktorJT

# Apply dotfiles with config mode and pass execution directory
chezmoi apply -- --env=$ENVIRONMENT --config=$CONFIG_MODE --localpath="$EXECUTION_DIR"
