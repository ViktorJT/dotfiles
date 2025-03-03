#!/bin/bash
set -e

# Get execution directory (where script was run)
EXECUTION_DIR="$(pwd)"

# Default environment
ENVIRONMENT="macos"

# Parse arguments
for arg in "$@"; do
  case $arg in
    --env=*)
      ENVIRONMENT="${arg#*=}"
      shift
      ;;
  esac
done

# Ensure ChezMoi is installed
if ! command -v chezmoi &> /dev/null; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

# Ensure ChezMoi is in PATH
export PATH="$HOME/.local/bin:$PATH"

#Initialize ChezMoi in the correct source
#if [[ "$CONFIG_MODE" == "local" ]]; then
echo "$EXECUTION_DIR"
chezmoi init --source="$EXECUTION_DIR" ViktorJT
#else
# chezmoi init ViktorJT
#fi

# Extract config mode
CONFIG_MODE=$(chezmoi data | jq -r ".chezmoidata.environments[\"$ENVIRONMENT\"].config")

# Apply dotfiles based on config mode
#if [[ "$CONFIG_MODE" == "local" ]]; then
#  chezmoi apply --source="$EXECUTION_DIR" -- --env=$ENVIRONMENT --config=$CONFIG_MODE
#else
#  chezmoi apply -- --env=$ENVIRONMENT --config=$CONFIG_MODE
#fi
