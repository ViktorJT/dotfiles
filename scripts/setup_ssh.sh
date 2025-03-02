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
    echo "✅ SSH key already exists. Skipping key generation."
    return
  fi

  # Use provided key name or fallback to `HOSTNAME + timestamp`
  SSH_KEY_LABEL="${1:-${HOSTNAME}-$(date +%Y%m%d-%H%M%S)}"
  SSH_KEY_PATH="$SSH_DIR/id_ed25519"

  echo "🔑 No SSH key found. Generating one..."
  ssh-keygen -t ed25519 -C "$SSH_KEY_LABEL" -f "$SSH_KEY_PATH" -N ""

  # Fix permissions
  chmod 600 "$SSH_KEY_PATH"

  echo "✅ SSH key successfully created!"
  
  # Automatically configure Git to use SSH
  echo "🔧 Configuring Git to use SSH..."
  git config --global url."ssh://git@github.com/".insteadOf "https://github.com/"
  echo "✅ Git is now set up to use SSH!"

  # Display the key for manual copying
  echo "🔓 Your public SSH key:"
  cat "$SSH_KEY_PATH.pub"

  # Try copying to clipboard
  if command -v pbcopy &>/dev/null; then
    pbcopy < "$SSH_KEY_PATH.pub"
    echo "📋 SSH key copied to clipboard!"
  elif command -v xclip &>/dev/null; then
    xclip -selection clipboard < "$SSH_KEY_PATH.pub"
    echo "📋 SSH key copied to clipboard!"
  elif command -v wl-copy &>/dev/null; then
    wl-copy < "$SSH_KEY_PATH.pub"
    echo "📋 SSH key copied to clipboard!"
  else
    echo "⚠️ Clipboard copy not supported. Manually copy the key above."
  fi

  # Instruct user to add SSH key to GitHub
  echo "📌 Add your SSH key to GitHub: https://github.com/settings/keys"
  echo "Once added, test the connection using:"
  echo "  ssh -T git@github.com"
}

# Run the function and pass any provided argument
setup_ssh_key "$1"