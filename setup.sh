#!/bin/bash

set -e  # Exit immediately if any command exits with a non-zero status

SCRIPTS_URL="https://raw.githubusercontent.com/ViktorJT/dotfiles/main/scripts"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

download_script() {
  local script_name=$1
  local output_path="$TEMP_DIR/$script_name"

  echo "📥 Downloading $script_name..."
  curl -fsSL "$SCRIPTS_URL/$script_name" -o "$output_path"
  chmod +x "$output_path"

  if [[ ! -f "$output_path" ]]; then
    echo "❌ Error: $script_name failed to download!" >&2
    exit 1  # Quit script if download fails
  fi

  echo "✅ Successfully downloaded $script_name!" >&2
  echo "$output_path"  # Only return the path
}

main() {
  echo "🚀 Starting universal setup script"

  # Download and source scripts with explicit error checking
  env_script=$(download_script "detect_environment.sh") || { echo "❌ Failed at detect_environment.sh"; exit 1; }
  source "$env_script"
  detect_environment

  deps_script=$(download_script "install_dependencies.sh") || { echo "❌ Failed at install_dependencies.sh"; exit 1; }
  source "$deps_script"
  install_dependencies

  chezmoi_script=$(download_script "install_chezmoi.sh") || { echo "❌ Failed at install_chezmoi.sh"; exit 1; }
  source "$chezmoi_script"
  install_chezmoi

  dotfiles_script=$(download_script "init_dotfiles.sh") || { echo "❌ Failed at init_dotfiles.sh"; exit 1; }
  source "$dotfiles_script"
  init_dotfiles

  env_specific_script=$(download_script "setup_environment.sh") || { echo "❌ Failed at setup_environment.sh"; exit 1; }
  source "$env_specific_script"
  setup_environment_specific

  ssh_script=$(download_script "setup_ssh.sh") || { echo "❌ Failed at setup_ssh.sh"; exit 1; }
  source "$ssh_script"
  setup_ssh_key "$1"

  echo -e "\n┌──────────────────────────────────────────────────┐"
  echo -e "│                                                  │"
  echo -e "│    NEXT STEPS                                    │"
  echo -e "│                                                  │"
  echo -e "│    •  Copy your SSH key manually:                │"
  echo -e "│       •  Run: cat ~/.ssh/id_ed25519.pub          │"
  echo -e "│       • Copy and add it to GitHub here:          │"
  echo -e "│         → https://github.com/settings/keys       │"
  echo -e "│                                                  │"
  echo -e "│    •  Test SSH connection:                       │"
  echo -e "│       • Run: ssh -T git@github.com               │"
  echo -e "│       • If successful, GitHub should say:        │"
  echo -e "│         \"You've successfully authenticated\"      │"
  echo -e "│                                                  │"
  echo -e "└──────────────────────────────────────────────────┘\n"

  echo -e "┌──────────────────────────────────────────────────┐"
  echo -e "│                                                  │"
  echo -e "│    USEFUL COMMANDS                               │"
  echo -e "│                                                  │"
  echo -e "│    •  chezmoi edit ~/.zshrc    - Edit Zsh        │"
  echo -e "│    •  chezmoi apply            - Apply changes   │"
  echo -e "│    •  chezmoi update           - Pull latest     │"
  echo -e "│    •  chezmoi cd               - Dotfiles dir    │"
  echo -e "│                                                  │"
  echo -e "└──────────────────────────────────────────────────┘\n"

  echo -e "     🎉 YOUR DEVELOPMENT ENVIRONMENT IS READY!\n"
}

main "$@"