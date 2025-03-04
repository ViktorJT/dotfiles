#!/bin/bash
set -e  # Exit on error

# Get execution directory (where script was run)
EXECUTION_DIR="$(pwd)"

# Default environment
ENVIRONMENT="macos"

for arg in "$@"; do
  [[ "$arg" == --env=* ]] && ENVIRONMENT="${arg#*=}"
done

if ! command -v chezmoi &> /dev/null; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

export PATH="$HOME/.local/bin:$PATH"

#ENV_DATA=$(curl -fsSL "https://raw.githubusercontent.com/ViktorJT/dotfiles/main/.chezmoidata/environments.yaml")

#CONFIG_MODE=$(echo "$ENV_DATA" | awk -v env="$ENVIRONMENT" '
#  $1 == "environments:" { in_env=1 } 
#  in_env && $1 == env ":" { found=1 }
#  found && $1 == "config:" { print $2; exit }
#')

#if [[ "$CONFIG_MODE" == "local" ]]; then
#  chezmoi init --source="$EXECUTION_DIR" ViktorJT
#else
#  chezmoi init ViktorJT
#fi

chezmoi init ViktorJT
chezmoi apply

# Apply chezmoi configuration
#if [[ "$CONFIG_MODE" == "local" ]]; then
#  LOCAL_CONFIG_PATH="$HOME/.config/chezmoi/chezmoi.toml"
#  mkdir -p "$(dirname "$LOCAL_CONFIG_PATH")"
#  echo "sourceDir = \"$EXECUTION_DIR\"" > "$LOCAL_CONFIG_PATH"
#  CHEZMOI_ENV="$ENVIRONMENT" chezmoi apply --config="$LOCAL_CONFIG_PATH" --source="$EXECUTION_DIR"
#else
#  chezmoi apply
#fi
