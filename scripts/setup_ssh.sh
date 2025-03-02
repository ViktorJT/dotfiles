#!/bin/bash

# Script to set up SSH keys for GitHub

setup_ssh_key() {
  # Determine home directory
  HOME_DIR=$HOME
  SSH_DIR="$HOME_DIR/.ssh"
  
  # Create .ssh directory if it doesn't exist
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"

  # Use provided key name or default to hostname + timestamp
  SSH_KEY_NAME="${1:-$(hostname)-$(date +%s)}"
  SSH_KEY_PATH="$SSH_DIR/$SSH_KEY_NAME"

  if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "🔑 No SSH key found. Generating one named: $SSH_KEY_NAME"

    # Generate SSH key with provided or default name
    ssh-keygen -t ed25519 -C "$SSH_KEY_NAME" -f "$SSH_KEY_PATH" -N ""

    # Fix permissions
    chmod 600 "$SSH_KEY_PATH"

    echo "✅ SSH key successfully created!"
    echo "🔓 Your public key:"
    cat "$SSH_KEY_PATH.pub"

    # Try to copy to clipboard if supported
    if [[ "$ENV_TYPE" == "darwin" ]]; then
      pbcopy < "$SSH_KEY_PATH.pub"
      echo "📋 SSH key copied to clipboard!"
    elif command -v xclip &>/dev/null; then
      xclip -selection clipboard < "$SSH_KEY_PATH.pub"
      echo "📋 SSH key copied to clipboard!"
    elif command -v wl-copy &>/dev/null; then
      wl-copy < "$SSH_KEY_PATH.pub"
      echo "📋 SSH key copied to clipboard!"
    else
      echo "⚠️ Clipboard copy not supported on this system. Manually copy the key above."
    fi

    echo "📌 Add your SSH key to GitHub: https://github.com/settings/keys"

    # Automatically attempt SSH connection
    echo "🔍 Testing SSH connection to GitHub..."
    mkdir -p "$SSH_DIR"
    ssh-keyscan github.com >> "$SSH_DIR/known_hosts" 2>/dev/null

    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
      echo "✅ SSH authentication successful!"
    else
      echo "❌ SSH authentication failed. Using HTTPS instead."
      export USE_HTTPS=true
    fi
  else
    echo "✅ SSH key already exists: $SSH_KEY_PATH, skipping..."
    
    # Auto-test SSH connection
    echo "🔍 Testing SSH connection to GitHub..."
    ssh-keyscan github.com >> "$SSH_DIR/known_hosts" 2>/dev/null
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
      echo "✅ SSH authentication successful!"
    else
      echo "❌ SSH authentication failed. Using HTTPS instead."
      export USE_HTTPS=true
    fi
  fi
}

# Call function with optional argument (from script execution)
setup_ssh_key "$1"