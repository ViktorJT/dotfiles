#!/bin/bash
# iPad host Docker-specific dependencies installer

echo "📱 Installing iPad host environment dependencies..."

# Update package index
apt update

# Install additional packages needed for development
apt install -y \
  build-essential \
  python3-pip \
  python3-venv \
  nodejs \
  npm \
  exa \
  bat

# Create symbolic links for bat (which might be installed as batcat on Ubuntu)
if [ ! -f /usr/bin/bat ] && [ -f /usr/bin/batcat ]; then
  ln -sf /usr/bin/batcat /usr/bin/bat
fi

# Install global Node.js packages
npm install -g \
  typescript \
  ts-node \
  prettier

# Set up Node.js environment
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  # Install latest LTS version of Node.js
  nvm install --lts
  nvm use --lts
fi

# Install Oh My Zsh theme if not already present
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/nord-extended" ]; then
  echo "🎨 Installing Nord theme for Oh My Zsh..."
  git clone https://github.com/ViktorJT/nord-extended.git "$HOME/.oh-my-zsh/custom/themes/nord-extended"
fi

echo "✅ iPad host dependencies installed successfully!"
