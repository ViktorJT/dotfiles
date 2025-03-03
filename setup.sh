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

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin init --apply ViktorJT -- --env=$ENVIRONMENT

echo "Dotfiles setup complete!"
