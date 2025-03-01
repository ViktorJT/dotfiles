#!/bin/bash

# Script to install chezmoi

install_chezmoi() {
  if command -v chezmoi &>/dev/null; then
    echo "✅ Chezmoi already installed"
  else
    echo "📦 Installing Chezmoi..."
    
    case $ENV_TYPE in
      darwin)
        if command -v brew &>/dev/null; then
          brew install chezmoi
        else
          echo "🍺 Installing Homebrew first..."
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          brew install chezmoi
        fi
        ;;
      *)
        # Universal install method
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $([[ $USE_SUDO == true ]] && echo "/usr/local/bin" || echo "$HOME/.local/bin")
        
        # Add to PATH if installed to ~/.local/bin
        if [[ $USE_SUDO == false ]]; then
          export PATH="$HOME/.local/bin:$PATH"
        fi
        ;;
    esac
  fi
  
  # Verify installation
  if command -v chezmoi &>/dev/null; then
    echo "✅ Chezmoi installed successfully"
    chezmoi --version
  else
    echo "❌ Failed to install Chezmoi"
    exit 1
  fi
}
