#!/bin/bash

# Script to set up environment-specific configurations

setup_environment_specific() {
  echo "🛠️ Setting up environment-specific configurations..."
  
  # Default user info
  USER_NAME="Viktor"
  USER_EMAIL="v.jensentorp@gmail.com"
  
  # Create chezmoi configuration with environment information
  echo "📝 Creating chezmoi configuration..."
  
  # Determine the current environment 
  isDocker="false"
  isMacOS="false"
  isLinux="false"
  dockerType=""
  
  # Use the detected environment from detect_environment.sh
  if [[ "$ENV_NAME" == "Docker" ]]; then
    isDocker="true"
    
    # Try to detect Docker container type based on hostname
    if [[ "$(hostname)" == *"web"* ]]; then
      dockerType="web"
    elif [[ "$(hostname)" == *"data"* ]]; then
      dockerType="data-science"
    elif [[ "$(hostname)" == *"dev"* ]]; then
      dockerType="ipad-host"
    else
      dockerType="dev"
    fi
    
  elif [[ "$ENV_NAME" == "macOS" ]]; then
    isMacOS="true"
  elif [[ "$ENV_NAME" == "Linux" ]]; then
    isLinux="true"
  fi
  
  # Create chezmoi configuration file
  mkdir -p "$HOME/.config/chezmoi"
  cat > "$HOME/.config/chezmoi/chezmoi.toml" << EOF
# chezmoi configuration file

[data]
    docker = ${isDocker}
    dockerType = "${dockerType}"
    macos = ${isMacOS}
    linux = ${isLinux}
    hostname = "$(hostname)"
    username = "$(whoami)"
    email = "${USER_EMAIL}"
    name = "${USER_NAME}"
EOF
  
  # Update git config if not already set
  if ! git config --global user.name >/dev/null 2>&1; then
    git config --global user.name "$USER_NAME"
    git config --global user.email "$USER_EMAIL"
    echo "✅ Git configuration updated!"
  else
    echo "✅ Git configuration already set!"
  fi
  
  echo "✅ Environment configuration set up!"
}