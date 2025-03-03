#!/bin/bash
set -e

REPO_URL="https://github.com/viktorjt/dotfiles.git"

# Parse arguments
ENVIRONMENT=""
SSH_KEY_NAME=""

for arg in "$@"; do
  case $arg in
    --env=*)
      ENVIRONMENT="${arg#*=}"
      shift
      ;;
    --ssh-key=*)
      SSH_KEY_NAME="${arg#*=}"
      shift
      ;;
  esac
done

# Ensure chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
  echo "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)"
fi

# Initialize chezmoi without cloning
chezmoi init --apply viktorjt

echo "Dotfiles setup complete!"