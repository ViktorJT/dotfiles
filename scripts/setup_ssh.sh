#!/bin/bash

# Script to generate an SSH key and configure Git to use SSH

setup_ssh_key() {
  HOME_DIR=$HOME
  SSH_DIR="$HOME_DIR/.ssh"

  # Create .ssh directory if it doesn't exist
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"

  # Check if an SSH key already exists
  if [[ -f "$SSH_DIR/id_ed25519" ]]; then
  	echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"	
    echo -e "   ✅  SSH key already exists. Skipping key generation."
  	echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
    return
  fi

  # Use provided key name or fallback to `HOSTNAME + timestamp`
  SSH_KEY_LABEL="${1:-${HOSTNAME}-$(date +%Y%m%d-%H%M%S)}"
  SSH_KEY_PATH="$SSH_DIR/id_ed25519"

  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "      🔑  No SSH key found. Generating a new one..."
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

  ssh-keygen -t ed25519 -C "$SSH_KEY_LABEL" -f "$SSH_KEY_PATH" -N ""

  # Fix permissions
  chmod 600 "$SSH_KEY_PATH"

  # Display SSH key
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "🔓  Your public SSH key (copy this and add it to GitHub):"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
  cat "$SSH_KEY_PATH.pub"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "                   📌  Next Steps:"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
  echo -e "  1️⃣  Copy the SSH key above and add it to GitHub:"
  echo -e "      🔗  https://github.com/settings/keys"
  echo -e ""
  echo -e "  2️⃣  Test your SSH connection to GitHub:"
  echo -e "      🛠️   ssh -T git@github.com"
  echo -e ""
  echo -e "  3️⃣  If authentication fails, manually add your key:"
  echo -e "      🔧   ssh-add ~/.ssh/id_ed25519"
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
	echo -e ""

  echo -e "       📋  Some useful commands:"
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "  • 📝  chezmoi edit ~/.zshrc  - Edit your zsh config"
  echo -e "  • ⚡  chezmoi apply          - Apply changes"
  echo -e "  • 🔄  chezmoi update         - Pull latest changes from repo"
  echo -e "  • 📂  chezmoi cd             - Go to your dotfiles directory"
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
  echo -e ""
  echo -e ""

  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "       🎉  Your development environment is ready!"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
}