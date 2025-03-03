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

echo "Setting up environment: $ENVIRONMENT in $EXECUTION_DIR"

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

# **Step 3: Initialize ChezMoi in the correct location**
#if [[ "$CONFIG_MODE" == "local" ]]; then
chezmoi init --source="$EXECUTION_DIR" ViktorJT
#else
#  chezmoi init ViktorJT
#fi

# **Step 4: Apply dotfiles using the correct config mode**
#if [[ "$CONFIG_MODE" == "local" ]]; then
chezmoi apply --source="$EXECUTION_DIR" -- --env=$ENVIRONMENT --config=$CONFIG_MODE
#else
#  chezmoi apply -- --env=$ENVIRONMENT --config=$CONFIG_MODE
#fi
