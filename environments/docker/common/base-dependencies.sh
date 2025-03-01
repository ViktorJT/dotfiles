#!/bin/bash
# Common base dependencies for all Docker containers

# Ensure necessary directories exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

# Install zsh plugins if not already present
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  echo "📦 Installing zsh-autosuggestions plugin..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  echo "📦 Installing zsh-syntax-highlighting plugin..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

# Install starship prompt if not already installed
if ! command -v starship &>/dev/null; then
  echo "📦 Installing Starship prompt..."
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

# Configure git with safe defaults if not already configured
if ! git config --global user.name >/dev/null 2>&1; then
  echo "📦 Setting up basic Git configuration..."
  git config --global user.name "Viktor"
  git config --global user.email "v.jensentorp@gmail.com"
  git config --global core.editor "nvim"
  git config --global init.defaultBranch "main"
fi

# Ensure ZSH is the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🔄 Setting zsh as default shell..."
  chsh -s $(which zsh)
fi

echo "✅ Common Docker dependencies configured"
