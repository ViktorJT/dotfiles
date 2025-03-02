#!/bin/bash

set -e  # Exit immediately if any command exits with a non-zero status

# Default configuration
SSH_KEY_NAME=""  # Default to hostname-timestamp if empty
UPDATE_DOTFILES=true  # Default to update dotfiles

# Parse command line arguments
for arg in "$@"; do
  case $arg in
    --ssh-key=*)
      SSH_KEY_NAME="${arg#*=}"
      ;;
    --update-dotfiles=*)
      UPDATE_DOTFILES="${arg#*=}"
      ;;
    *)
      # If no recognized pattern, assume it's the SSH key name
      if [[ -z "$SSH_KEY_NAME" ]]; then
        SSH_KEY_NAME="$arg"
      fi
      ;;
  esac
done

# Export variables for other scripts to use
export UPDATE_DOTFILES

SCRIPTS_URL="https://raw.githubusercontent.com/ViktorJT/dotfiles/main/scripts"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

download_script() {
  local script_name=$1
  local output_path="$TEMP_DIR/$script_name"

  echo "📥 Downloading $script_name to $output_path..." >&2
  curl -fsSL "$SCRIPTS_URL/$script_name" -o "$output_path"

  # Check if download was successful
  if [[ ! -f "$output_path" || ! -s "$output_path" ]]; then
    echo "❌ Error: Failed to download $script_name!" >&2
    return 1
  fi

  chmod +x "$output_path"
  echo "$output_path"
}

main() {
  echo "🚀 Starting universal setup script"
  echo "📋 Configuration:"
  echo "  - SSH Key Name: ${SSH_KEY_NAME:-'auto-generated'}"
  echo "  - Update Dotfiles: $UPDATE_DOTFILES"

  # Download and source scripts with proper error handling
  env_script=$(download_script "detect_environment.sh")
  source "$env_script"
  detect_environment

  deps_script=$(download_script "install_dependencies.sh")
  source "$deps_script"
  install_dependencies

  chezmoi_script=$(download_script "install_chezmoi.sh")
  source "$chezmoi_script"
  install_chezmoi

  # Set up environment before initializing dotfiles
  env_specific_script=$(download_script "setup_environment.sh")
  source "$env_specific_script"
  setup_environment_specific

  # Now initialize dotfiles with correct environment settings
  dotfiles_script=$(download_script "init_dotfiles.sh")
  source "$dotfiles_script"
  init_dotfiles

  ssh_script=$(download_script "setup_ssh.sh")
  source "$ssh_script"
  setup_ssh_key "$SSH_KEY_NAME"

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