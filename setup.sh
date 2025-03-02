#!/bin/bash

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
    exit 1
  fi

  echo "$output_path"
}

main() {
  echo "🚀 Starting universal setup script"

  # Download and source scripts
  env_script=$(download_script "detect_environment.sh")
  source "$env_script"
  detect_environment

  deps_script=$(download_script "install_dependencies.sh")
  source "$deps_script"
  install_dependencies

  chezmoi_script=$(download_script "install_chezmoi.sh")
  source "$chezmoi_script"
  install_chezmoi

  dotfiles_script=$(download_script "init_dotfiles.sh")
  source "$dotfiles_script"
  init_dotfiles

  env_specific_script=$(download_script "setup_environment.sh")
  source "$env_specific_script"
  setup_environment_specific

  # Download and source SSH setup script
  ssh_script=$(download_script "setup_ssh.sh")
  source "$ssh_script"
  setup_ssh_key "$1"  # Call function with optional ssh-key name argument
  
  echo "📌 Next Steps:"
  echo "1️⃣ Copy the SSH key above and add it to GitHub: https://github.com/settings/keys"
  echo "2️⃣ Test the SSH connection to GitHub:"
  echo "   ssh -T git@github.com"
  echo "3️⃣ If authentication fails, ensure you've added the key to GitHub and run:"
  echo "   ssh-add ~/.ssh/id_ed25519"
  echo ""
  echo "📋 Some useful commands:"
  echo "  • chezmoi edit ~/.zshrc  - Edit your zsh config"
  echo "  • chezmoi apply          - Apply changes"
  echo "  • chezmoi update         - Pull latest changes from repo"
  echo "  • chezmoi cd             - Go to your dotfiles directory"
  echo ""
  echo "🎉 Your development environment is ready!"
}

main "$@"