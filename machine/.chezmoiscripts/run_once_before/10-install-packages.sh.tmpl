#!/bin/bash
# macOS-specific dependencies installer

echo "🍎 Installing macOS-specific dependencies..."

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH based on architecture
  if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    # Intel
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrew already installed"
fi

# Install essential command line tools
echo "📦 Installing CLI tools..."
brew install \
  git \
  neovim \
  tmux \
  ripgrep \
  fzf \
  bat \
  exa \
  fd \
  jq \
  starship \
  zsh

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🔧 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install ZSH plugins
brew install zsh-autosuggestions zsh-syntax-highlighting

# Install Node.js environment
echo "📦 Installing Node.js environment..."
brew install nvm
mkdir -p "$HOME/.nvm"

# Install development applications
echo "📦 Installing development applications..."
brew install --cask \
  visual-studio-code \
  wezterm \
  iterm2 \
  raycast

# Install fonts
echo "📦 Installing fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-victor-mono-nerd-font

echo "✅ macOS dependencies installed successfully!"
