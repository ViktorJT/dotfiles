#!/bin/bash

# Script to set up SSH keys for GitHub

setup_ssh_key() {
  # Determine home directory
  HOME_DIR=$HOME
  SSH_DIR="$HOME_DIR/.ssh"
  
  # Create .ssh directory if it doesn't exist
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
  
  if [[ ! -f "$SSH_DIR/id_ed25519" ]]; then
    echo "🔑 No SSH key found. Let's generate one!"
    
    # Loop until a valid name is entered
    while true; do
      echo -n "Enter a name for this SSH key (e.g., 'macbook-pro'): "
      read ssh_key_label
      
      # Check if input is empty
      if [[ -z "$ssh_key_label" ]]; then
        echo "❌ Error: SSH key name cannot be empty. Please enter a valid name."
        continue
      fi
      
      # Check if input contains only valid characters
      if [[ ! "$ssh_key_label" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "❌ Error: SSH key name can only contain letters, numbers, dashes (-), and underscores (_)."
        continue
      fi
      
      # If input is valid, break out of the loop
      break
    done
    
    # Generate SSH key with the validated label
    ssh-keygen -t ed25519 -C "$ssh_key_label" -f "$SSH_DIR/id_ed25519" -N ""
    
    # Fix permissions
    chmod 600 "$SSH_DIR/id_ed25519"
    
    echo "✅ SSH key successfully created!"
    
    echo "🔓 Your public key:"
    cat "$SSH_DIR/id_ed25519.pub"
    
    # Try to copy to clipboard based on OS
    if [[ "$ENV_TYPE" == "darwin" ]]; then
      pbcopy < "$SSH_DIR/id_ed25519.pub"
      echo "📋 SSH key copied to clipboard!"
    elif command -v xclip &>/dev/null; then
      xclip -selection clipboard < "$SSH_DIR/id_ed25519.pub"
      echo "📋 SSH key copied to clipboard!"
    elif command -v wl-copy &>/dev/null; then
      wl-copy < "$SSH_DIR/id_ed25519.pub"
      echo "📋 SSH key copied to clipboard!"
    else
      echo "⚠️ Clipboard copy not supported on this system. Manually copy the key above."
    fi
    
    echo "📌 Add your SSH key to GitHub: https://github.com/settings/keys"
    read -p "Press Enter once you've added the SSH key to GitHub (or type 'skip' to continue without verification): " verify_choice
    
    if [[ "$verify_choice" != "skip" ]]; then
      # Ensure GitHub is in known_hosts
      mkdir -p "$SSH_DIR"
      ssh-keyscan github.com >> "$SSH_DIR/known_hosts" 2>/dev/null
      
      echo "🔍 Testing SSH connection to GitHub..."
      if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✅ SSH authentication successful!"
      else
        echo "❌ SSH authentication failed."
        echo "Would you like to:"
        echo "1) Try again"
        echo "2) Use HTTPS instead of SSH"
        echo "3) Continue anyway"
        read -p "Enter your choice (1-3): " ssh_choice
        
        case $ssh_choice in
          1)
            # Recursive call to try again
            setup_ssh_key
            ;;
          2)
            echo "Switching to HTTPS authentication"
            export USE_HTTPS=true
            ;;
          3)
            echo "Continuing with setup..."
            ;;
          *)
            echo "Invalid choice. Continuing with setup..."
            ;;
        esac
      fi
    else
      echo "Skipping SSH verification..."
      export USE_HTTPS=true
    fi
  else
    echo "✅ SSH key already exists, skipping..."
    
    # Ask if they want to test the connection
    read -p "Would you like to test the SSH connection to GitHub? (y/n): " test_ssh
    if [[ "$test_ssh" == "y" ]]; then
      # Ensure GitHub is in known_hosts
      ssh-keyscan github.com >> "$SSH_DIR/known_hosts" 2>/dev/null
      
      echo "🔍 Testing SSH connection to GitHub..."
      if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✅ SSH authentication successful!"
      else
        echo "❌ SSH authentication failed."
        echo "Would you like to use HTTPS instead? (y/n): " use_https
        if [[ "$use_https" == "y" ]]; then
          export USE_HTTPS=true
        fi
      fi
    fi
  fi
}
