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
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
fi

export PATH="$HOME/.local/bin:$PATH"

chezmoi init ViktorJT
CHEZMOI_ENVIRONMENT="$ENVIRONMENT" chezmoi apply
