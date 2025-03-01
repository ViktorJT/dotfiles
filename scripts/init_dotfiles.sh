#!/bin/bash

# Script to initialize dotfiles with chezmoi

# Default dotfiles repository
DEFAULT_REPO="git@github.com:ViktorJT/dotfiles.git"
HTTPS_REPO="https://github.com/ViktorJT/dotfiles.git"

init_dotfiles() {
  if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "⚙ Initializing dotfiles..."
    
    # Ask for dotfiles repository
    read -p "Enter your dotfiles repository URL (Press Enter for default: $DEFAULT_REPO): " dotfiles_repo
    dotfiles_repo=${dotfiles_repo:-$DEFAULT_REPO}
    
    # Use HTTPS if SSH failed or was skipped
    if [[ "$USE_HTTPS" == true ]]; then
      echo "Using HTTPS authentication for GitHub"
      dotfiles_repo=$HTTPS_REPO
      chezmoi init "$dotfiles_repo"
    else
      chezmoi init "$dotfiles_repo" --ssh
    fi
    
    echo "🎨 Applying dotfiles..."
    chezmoi apply
  else
    echo "✅ Chezmoi already initialized!"
    
    echo "Would you like to update your dotfiles? (y/n): "
    read update_dotfiles
    
    if [[ "$update_dotfiles" == "y" ]]; then
      echo "🔄 Updating dotfiles..."
      chezmoi update
    fi
  fi
}
