#!/bin/bash
set -e

# Default values
ENVIRONMENT="macos"

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

# Apply dotfiles with correct environment
chezmoi apply -- --env=$ENVIRONMENT
