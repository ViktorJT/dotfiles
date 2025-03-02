#!/bin/bash

# Script to initialize dotfiles with chezmoi

# Default dotfiles repository
DEFAULT_REPO="git@github.com:ViktorJT/dotfiles.git"
HTTPS_REPO="https://github.com/ViktorJT/dotfiles.git"

init_dotfiles() {
  if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "⚙ Initializing dotfiles..."
    
    # Use the default repo
    dotfiles_repo=$DEFAULT_REPO
    
    # Use HTTPS if requested
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
    
    # Check if we should update dotfiles
    if [[ "$UPDATE_DOTFILES" == true ]]; then
      echo "🔄 Updating dotfiles..."
      chezmoi update
    else
      echo "⏭️ Skipping dotfiles update as requested."
    fi
  fi
}