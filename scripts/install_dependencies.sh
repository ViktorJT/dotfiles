#!/bin/bash

# Script to install core dependencies

install_dependencies() {
  echo "📦 Installing core dependencies..."
  
  # First, check for chezmoi - if already installed, skip this step
  if command -v chezmoi &>/dev/null; then
    echo "✅ Chezmoi already installed, skipping dependencies installation"
    return 0
  fi
  
  # Install git if not available
  if ! command -v git &>/dev/null; then
    echo "Installing git..."
    case $PKG_MANAGER in
      brew)
        brew install git
        ;;
      apt)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") apt update
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") apt install -y git
        ;;
      dnf)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") dnf install -y git
        ;;
      pacman)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") pacman -Sy --noconfirm git
        ;;
      *)
        echo "⚠️ Unknown package manager. Please install git manually."
        ;;
    esac
  fi
  
  # Install curl if not available
  if ! command -v curl &>/dev/null; then
    echo "Installing curl..."
    case $PKG_MANAGER in
      brew)
        brew install curl
        ;;
      apt)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") apt update
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") apt install -y curl
        ;;
      dnf)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") dnf install -y curl
        ;;
      pacman)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") pacman -Sy --noconfirm curl
        ;;
      *)
        echo "⚠️ Unknown package manager. Please install curl manually."
        ;;
    esac
  fi
  
  # Install zsh if not available
  if ! command -v zsh &>/dev/null; then
    echo "Installing zsh..."
    case $PKG_MANAGER in
      brew)
        brew install zsh
        ;;
      apt)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") apt update
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") apt install -y zsh
        ;;
      dnf)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") dnf install -y zsh
        ;;
      pacman)
        $([[ $USE_SUDO == true ]] && echo "sudo" || echo "") pacman -Sy --noconfirm zsh
        ;;
      *)
        echo "⚠️ Unknown package manager. Please install zsh manually."
        ;;
    esac
  fi
  
  echo "✅ Core dependencies installed"
}
