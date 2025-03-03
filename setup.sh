#!/bin/bash
set -e

echo "$HOME"

# Detect if /tmp is noexec and create an alternative tmp directory if needed
# if mount | grep '/tmp' | grep -q 'noexec'; then
#  mkdir -p "$HOME/.local/share/chezmoi/tmp"
# fi

# Parse arguments
# ENVIRONMENT="macos"
# SSH_KEY_NAME=""

# for arg in "$@"; do
#  case $arg in
#    --env=*)
#      ENVIRONMENT="${arg#*=}"
#      shift
#      ;;
#    --ssh-key=*)
#      SSH_KEY_NAME="${arg#*=}"
#      shift
#      ;;
#  esac
#done


#echo "Setting up environment: $ENVIRONMENT"

# Install chezmoi and apply dotfiles in one step
# sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin

# Initialize chezmoi (defaults to dotfiles repo when passing a Github username)
# chezmoi init ViktorJT

# Apply dotfiles with the environment variable
# chezmoi apply -- --env=$ENVIRONMENT

# echo "Dotfiles setup complete!"
