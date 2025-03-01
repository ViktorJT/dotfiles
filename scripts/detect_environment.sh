#!/bin/bash

# Script to detect the current environment

detect_environment() {
  echo "🔍 Detecting environment..."
  
  # Define variables to hold environment information
  export ENV_NAME=""
  export ENV_TYPE=""
  export PKG_MANAGER=""
  export USE_SUDO=true
  
  # Check if we're in a Docker container
  if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup 2>/dev/null; then
    ENV_NAME="Docker"
    ENV_TYPE="linux"
    USE_SUDO=false
    echo "🐳 Docker environment detected"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    ENV_NAME="macOS"
    ENV_TYPE="darwin"
    PKG_MANAGER="brew"
    echo "🍎 macOS environment detected"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ENV_NAME="Linux"
    ENV_TYPE="linux"
    
    # Detect Linux distribution
    if [ -f /etc/debian_version ]; then
      echo "🐧 Debian/Ubuntu Linux detected"
      PKG_MANAGER="apt"
    elif [ -f /etc/fedora-release ]; then
      echo "🐧 Fedora Linux detected"
      PKG_MANAGER="dnf"
    elif [ -f /etc/arch-release ]; then
      echo "🐧 Arch Linux detected"
      PKG_MANAGER="pacman"
    else
      echo "🐧 Generic Linux detected, will try to determine package manager"
      if command -v apt &>/dev/null; then
        PKG_MANAGER="apt"
      elif command -v dnf &>/dev/null; then
        PKG_MANAGER="dnf"
      elif command -v pacman &>/dev/null; then
        PKG_MANAGER="pacman"
      else
        echo "❌ Could not determine package manager. Please install dependencies manually."
        PKG_MANAGER="unknown"
      fi
    fi
  else
    echo "⚠️ Unknown environment: $OSTYPE"
    ENV_NAME="Unknown"
    ENV_TYPE="unknown"
  fi
  
  echo "✅ Environment detected as: $ENV_NAME using ${PKG_MANAGER:-'no package manager'}"
}
