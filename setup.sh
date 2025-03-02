#!/bin/bash

###################
# --- WELCOME --- #
###################

: '
  Universal Setup Script
  
  ┌–– Overview –––––––––––––––––––––––––––––––––┐
  │                                             │
  │   - Detect environment                      │
  │   - Install dependencies                    │
  │   - Setup SSH key                           │
  │   - Init dotfiles with chezmoi              │
  │                                             │
  └–––––––––––––––––––––––––––––––––––––––––––––┘
'

# Pass the SSH key name (if provided) to the setup_ssh script
bash setup_ssh.sh "$1"

# Define base URL for raw script downloads
SCRIPTS_URL="https://raw.githubusercontent.com/ViktorJT/dotfiles/main/scripts"

# Create temporary directory for scripts
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to download a script
download_script() {
  local script_name=$1
  local output_path="$TEMP_DIR/$script_name"

  curl -fsSL "https://raw.githubusercontent.com/ViktorJT/dotfiles/main/scripts/$script_name" -o "$output_path"
  chmod +x "$output_path"

  # Only output the path, no extra log messages
  printf "%s" "$output_path"
}

# Main execution
main() {
  echo "🚀 Starting universal setup script"
  
  # Initialize variables
  export USE_HTTPS=false
  
  # Download and source environment detection script
  env_script=$(download_script "detect_environment.sh")
  source "$env_script"
  detect_environment
  
  # Download and source dependencies script
  deps_script=$(download_script "install_dependencies.sh")
  source "$deps_script"
  install_dependencies
  
  # Download and source chezmoi installation script
  chezmoi_script=$(download_script "install_chezmoi.sh")
  source "$chezmoi_script"
  install_chezmoi
  
  # Download and source SSH key setup script
  ssh_script=$(download_script "setup_ssh.sh")
  source "$ssh_script"
  setup_ssh_key
  
  # Download and source dotfiles initialization script
  dotfiles_script=$(download_script "init_dotfiles.sh")
  source "$dotfiles_script"
  init_dotfiles
  
  # Download and source environment-specific setup script
  env_specific_script=$(download_script "setup_environment.sh")
  source "$env_specific_script"
  setup_environment_specific
  
  echo
  echo "✅ Setup complete!"
  echo
  echo "📋 Some useful commands:"
  echo "  • chezmoi edit ~/.zshrc  - Edit your zsh config"
  echo "  • chezmoi apply          - Apply changes" 
  echo "  • chezmoi update         - Pull latest changes from repo"
  echo "  • chezmoi cd             - Go to your dotfiles directory"
  echo
  echo "🎉 Your development environment is ready!"
}

# Run the main function
main
