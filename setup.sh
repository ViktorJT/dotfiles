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

# **Step 1: Fetch `environments.yaml` before initializing ChezMoi**
ENV_DATA=$(curl -fsSL "https://raw.githubusercontent.com/ViktorJT/dotfiles/main/.chezmoidata/environments.yaml")

# **Step 2: Extract config_mode
CONFIG_MODE=$(echo "$ENV_DATA" | awk -v env="$ENVIRONMENT" '
  $1 == "environments:" { in_env=1 } 
  in_env && $1 == env ":" { found=1 }
  found && $1 == "config:" { print $2; exit }
')

echo "Detected config mode: $CONFIG_MODE"

# chezmoi init --source="$EXECUTION_DIR" ViktorJT

# Initialize ChezMoi in the correct source
if [[ "$CONFIG_MODE" == "local" ]]; then
  echo "$EXECUTION_DIR"
  chezmoi init --source="$EXECUTION_DIR" ViktorJT
else
  echo "DEBUGGING: trying to install globally for some reason"
#  chezmoi init ViktorJT
fi

# Extract config mode
CONFIG_MODE=$(chezmoi data | jq -r ".chezmoidata.environments[\"$ENVIRONMENT\"].config")

echo "config mode from environments file: $CONFIG_MODE"

# Apply dotfiles based on config mode
#if [[ "$CONFIG_MODE" == "local" ]]; then
#  chezmoi apply --source="$EXECUTION_DIR" -- --env=$ENVIRONMENT --config=$CONFIG_MODE
#else
#  chezmoi apply -- --env=$ENVIRONMENT --config=$CONFIG_MODE
#fi
